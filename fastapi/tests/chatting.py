from datetime import timedelta
import random
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
            db.execute(delete(Topic))
            db.execute(delete(Intimacy))
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
            seq_ids = list(
                db.scalars(
                    insert(Text)
                    .values(
                        [
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp,
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp + timedelta(milliseconds=1),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp + timedelta(milliseconds=2),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp + timedelta(milliseconds=3),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp + timedelta(milliseconds=4),
                            },
                        ]
                    )
                    .returning(Text.id)
                )
            )
            db.commit()

            self.assertEqual(get_all_texts(-1, chatting.id, -1, None, None, db), [])
            self.assertEqual(get_all_texts(-1, None, -1, None, None, db), [])
            self.assertEqual(get_all_texts(self.initiator_id, -1, -1, None, None, db), [])
            self.assertEqual(
                len(get_all_texts(self.initiator_id, chatting.id, -1, None, None, db)), 5
            )
            self.assertEqual(
                len(get_all_texts(self.initiator_id, None, -1, None, None, db)), 5
            )
            self.assertEqual(
                len(get_all_texts(self.initiator_id, None, seq_ids[1], None, None, db)), 3
            )

            texts = get_all_texts(self.initiator_id, None, seq_ids[1], 2, None, db)
            self.assertEqual(len(texts), 2)
            self.assertEqual(texts[0].id, seq_ids[4])
            self.assertEqual(texts[1].id, seq_ids[3])

            texts = get_all_texts(self.initiator_id, None, seq_ids[1], None, timestamp + timedelta(milliseconds=3), db)
            self.assertEqual(len(texts), 2)
            self.assertEqual(texts[0].id, seq_ids[3])
            self.assertEqual(texts[1].id, seq_ids[2])

    def test_get_topic(self):
        for db in DbConnector.get_db():
            db.execute(
                insert(Topic).values(
                    [
                        {"topic": "I'm so good", "tag": "A"},
                        {"topic": "I'm so mad", "tag": "B"},
                        {"topic": "I'm so sad", "tag": "C"},
                        {"topic": "I'm so happy", "tag": "C"}
                    ]
                )
            )
            db.commit()
            self.assertIn(get_topic('C', db), ["I'm so sad", "I'm so happy"])
            self.assertEqual(get_topic('B', db), "I'm so mad")
            self.assertEqual(get_topic('A', db), "I'm so good")

    def test_get_intimacy(self):
        # Test case 1: Get intimacy for a chatting
        # user_id = 1
        # chatting_id = 1
        # expected_result = 50.0
        timestamp = datetime.now()
        for db in DbConnector.get_db():
            chatting = create_chatting(self.initiator_id, self.responder_id, db)

            seq_ids = list(
                db.scalars(
                    insert(Text)
                    .values(
                        [
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp,
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "hello",
                                "timestamp": timestamp - timedelta(seconds=1),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.responder_id,
                                "msg": "you",
                                "timestamp": timestamp - timedelta(seconds=2),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.initiator_id,
                                "msg": "what",
                                "timestamp": timestamp - timedelta(seconds=3),
                            },
                            {
                                "chatting_id": chatting.id,
                                "sender_id": self.responder_id,
                                "msg": "bye",
                                "timestamp": timestamp - timedelta(seconds=4),
                            },
                        ]
                    )
                    .returning(Text.id)
                )
            )
            chatting = approve_chatting(self.responder_id, chatting.id, db)

            db.commit()

            self.assertEqual(
                get_intimacy(self.initiator_id, chatting.id, db), 40.999562680485
            )

    def test_flatten_texts(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        expected_result = "Hello"
        result = flatten_texts(texts)
        self.assertEqual(result, expected_result)

    def test_score_frequency(self):
        # Test case 1: Score frequency of texts
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        expected_result = 10
        result = score_frequency(texts)
        self.assertEqual(result, expected_result)

    def test_score_frequency_delta(self):
        # Test case 1: Score frequency delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now())
        ]
        expected_result = 0
        result = score_frequency_delta(prev_texts, curr_texts)
        self.assertEqual(result, expected_result)

    def test_score_avg_length(self):
        # Test case 1: Score average length of texts
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        expected_result = 0
        result = score_avg_length(texts)
        self.assertEqual(result, expected_result)

    def test_score_avg_length_delta(self):
        # Test case 1: Score average length delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now())
        ]
        expected_result = 0
        result = score_avg_length_delta(prev_texts, curr_texts)
        self.assertEqual(result, expected_result)

    def test_get_turn(self):
        # Test case 1: Get turn rate of texts
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now()),
        ]
        user_id = 1
        expected_result = 0.5
        result = get_turn(texts, user_id)
        self.assertEqual(result, expected_result)

    def test_get_turn_delta(self):
        # Test case 1: Get turn delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now())
        ]
        user_id = 1
        expected_result = 0
        result = get_turn_delta(prev_texts, curr_texts, user_id)
        self.assertEqual(result, expected_result)

    def test_score_turn(self):
        # Test case 1: Score turn rate of texts
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now()),
        ]
        user_id = 1
        expected_result = 10
        result = score_turn(texts, user_id)
        self.assertEqual(result, expected_result)

    def test_score_turn_delta(self):
        # Test case 1: Score turn delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now())
        ]
        user_id = 1
        expected_result = 0
        result = score_turn_delta(prev_texts, curr_texts, user_id)
        self.assertEqual(result, expected_result)

    def test_change_weight(self):
        # Test case 1: Change weight of parameters
        weight = [0.1, 0.3, 0, 0.3, 0, 0.3, 0]
        expected_result = [0.1, 0.3, 0, 0.3, 0, 0.3, 0]
        result = change_weight(weight)
        self.assertEqual(result, expected_result)


if __name__ == "__main__":
    unittest.main()
