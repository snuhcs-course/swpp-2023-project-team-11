from datetime import timedelta
import unittest

from sqlalchemy import insert, delete, select

from src.database import Base, DbConnector
from src.chatting.dependencies import *
from src.chatting.models import *
from src.chatting.service import *
from tests.utils import *


class TestDependencies(unittest.TestCase):
    email = "test@snu.ac.kr"
    invalid = "hello@snu.ac.kr"

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.profile_id = setup_user(db, cls.email)
            db.commit()

    @classmethod
    def tearDownClass(cls) -> None:
        for db in DbConnector.get_db():
            teardown_user(db)
            db.commit()

    def test_get_user_id(self) -> None:
        valid_req = CreateChattingRequest(counterpart=self.email)
        invalid_req = CreateChattingRequest(counterpart=self.invalid)

        for db in DbConnector.get_db():
            self.assertEqual(self.profile_id, get_user_id(valid_req, db))
            with self.assertRaises(InvalidUserException):
                get_user_id(invalid_req, db)


class TestService(unittest.TestCase):
    initiator = "test@snu.ac.kr"
    responder = "hello@snu.ac.kr"

    @classmethod
    def setUpClass(cls) -> None:
        Base.metadata.create_all(bind=DbConnector.engine)
        for db in DbConnector.get_db():
            cls.initiator_id = setup_user(db, cls.initiator)
            cls.responder_id = setup_user(db, cls.responder)
            db.commit()
    
    @classmethod
    def tearDownClass(cls) -> None:
        for db in DbConnector.get_db():
            teardown_user(db)
            db.commit()

    def tearDown(self) -> None:
        for db in DbConnector.get_db():
            db.execute(delete(Text))
            db.execute(delete(Chatting))
            db.commit()

    def test_chatting(self):
        for db in DbConnector.get_db():
            chatting = create_chatting(self.initiator_id, self.responder_id, db)
            chatting_id = chatting.id
            self.assertIsNotNone(chatting)
            self.assertEqual(chatting.is_approved, False)
            self.assertEqual(chatting.is_terminated, False)
            db.commit()

            self.assertEqual(get_all_chattings(self.initiator_id, True, db), [])
            self.assertEqual(len(get_all_chattings(self.initiator_id, False, db)), 1)
            self.assertEqual(len(get_all_chattings(self.responder_id, False, db)), 1)

            with self.assertRaises(InvalidChattingException):
                approve_chatting(self.initiator_id, chatting_id, db)
            with self.assertRaises(InvalidChattingException):
                approve_chatting(self.responder_id, -1, db)
            chatting = approve_chatting(self.responder_id, chatting_id, db)
            db.commit()

            self.assertEqual(chatting.id, chatting_id)
            self.assertEqual(len(get_all_chattings(self.initiator_id, True, db)), 1)
            self.assertEqual(len(get_all_chattings(self.initiator_id, False, db)), 0)

            with self.assertRaises(InvalidChattingException):
                terminate_chatting(-1, chatting_id, db)
            with self.assertRaises(InvalidChattingException):
                terminate_chatting(self.initiator_id, -1, db)
            chatting = terminate_chatting(self.initiator_id, chatting_id, db)
            self.assertEqual(chatting.is_terminated, True)
            chatting = terminate_chatting(self.responder_id, chatting_id, db)
            db.commit()

    def test_get_all_texts(self):
        timestamp = datetime.now()

        for db in DbConnector.get_db():
            chatting = create_chatting(self.initiator_id, self.responder_id, db)
            seq_ids = list(db.scalars(insert(Text).values([
                {"chatting_id": chatting.id, "sender_id": self.initiator_id, "msg": "hello", "timestamp": timestamp},
                {"chatting_id": chatting.id, "sender_id": self.initiator_id, "msg": "hello", "timestamp": timestamp + timedelta(milliseconds=1)},
                {"chatting_id": chatting.id, "sender_id": self.initiator_id, "msg": "hello", "timestamp": timestamp + timedelta(milliseconds=2)},
                {"chatting_id": chatting.id, "sender_id": self.initiator_id, "msg": "hello", "timestamp": timestamp + timedelta(milliseconds=3)},
                {"chatting_id": chatting.id, "sender_id": self.initiator_id, "msg": "hello", "timestamp": timestamp + timedelta(milliseconds=4)},
            ]).returning(Text.id)))
            db.commit()

            self.assertEqual(get_all_texts(-1, chatting.id, -1, None, db), [])
            self.assertEqual(get_all_texts(-1, None, -1, None, db), [])
            self.assertEqual(get_all_texts(self.initiator_id, -1, -1, None, db), [])
            self.assertEqual(len(get_all_texts(self.initiator_id, chatting.id, -1, None, db)), 5)
            self.assertEqual(len(get_all_texts(self.initiator_id, None, -1, None, db)), 5)
            self.assertEqual(len(get_all_texts(self.initiator_id, None, seq_ids[1], None, db)), 3)

            texts = get_all_texts(self.initiator_id, None, seq_ids[1], 2, db)
            self.assertEqual(len(texts), 2)
            self.assertEqual(texts[0].id, seq_ids[4])
            self.assertEqual(texts[1].id, seq_ids[3])


if __name__ == '__main__':
    unittest.main()
