from datetime import timedelta
import random
import unittest
from unittest.mock import patch, Mock

from sqlalchemy import insert, delete, select

import src.chatting.service
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

            # TODO intimacy insert 됐는지 확인하는 test 추가해주세요

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

    # TODO 실제로 clova, papago API 호출하는 unit test 각각 하나씩 만들어주세요.
    def test_clova_api(self):
        with self.assertRaises(ExternalApiError):
            call_clova_api("")
        response = call_clova_api("I am Happy!")
        self.assertEqual(response.status_code, 200)
        print(response.json())

    def test_papago_api(self):
        with self.assertRaises(ExternalApiError):
            call_papago_api("")
        response = call_papago_api("I am Happy!")
        self.assertEqual(response.status_code, 200)
        print(response.json())

    # TODO Clova & Papago API 호출하는 함수 (translate_text, get_sentiment) 모킹해서 실제로 두 API 호출하지 않도록 해주세요
    @patch("src.chatting.service.requests.post")
    def test_get_sentiment(self, mock_clova):
        mock_response = Mock()
        mock_response.status_code = 200
        data = {
            'document': {'sentiment': 'positive',
                         'confidence': {'negative': 0.030769918, 'positive': 99.964096, 'neutral': 0.00513428}},
            'sentences': [{'content': 'I am Happy!', 'offset': 0, 'length': 11, 'sentiment': 'positive',
                           'confidence': {'negative': 0.0018461951, 'positive': 0.99784577, 'neutral': 0.0003080568},
                           'highlights': [{'offset': 0, 'length': 10}]}]
        }
        mock_response.text = json.dumps(data)
        mock_clova.return_value = mock_response

        response = get_sentiment("")
        self.assertEqual(response, 9.9933326082)

    @patch("src.chatting.service.requests.post")
    def test_translate_text(self, mock_papago):
        mock_response = Mock()
        mock_response.status_code = 200
        data = {
            'message': {'result':
                            {'srcLangType': 'en', 'tarLangType': 'ko', 'translatedText': '나는 행복해!'}
                        }
        }

        mock_response.json.return_value = data
        mock_papago.return_value = mock_response

        response = translate_text("I'm so sad..")
        self.assertEqual(response, "나는 행복해!")

    @patch("src.chatting.service.requests.post")
    def test_get_intimacy(self, mock_apis):
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
            create_intimacy(self.initiator_id, chatting.id, db)
            db.commit()

            print(get_sentiment("asdf"))
            print(translate_text(""))
            print("asdfasdf")
            intimacy = get_intimacy(user_id=self.initiator_id, chatting_id=chatting.id, limit=None, timestamp=None, db = db)[0].intimacy

            self.assertEqual(
                intimacy, 40.999562680485
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

    def test_get_frequency(self):
        timestamp = datetime.now()
        texts = [
            Text(id=1, chatting_id=1, sender_id=1, msg="", timestamp=timestamp - timedelta(seconds=1)),
            Text(id=1, chatting_id=1, sender_id=1, msg="", timestamp=timestamp - timedelta(seconds=2)),
            Text(id=1, chatting_id=1, sender_id=1, msg="", timestamp=timestamp - timedelta(seconds=3)),
            Text(id=1, chatting_id=1, sender_id=1, msg="", timestamp=timestamp - timedelta(seconds=8)),
        ]
        result = get_frequency(texts)
        self.assertGreaterEqual(result, 39.9)
        self.assertLessEqual(result, 40.1)

        self.assertIsNone(get_frequency([]))

    def test_get_frequency_delta(self):
        self.assertIsNone(get_frequency_delta([], []))

    def test_score_frequency(self):
        text = Text(id=1, chatting_id=1, sender_id=1, msg="", timestamp=datetime.now() - timedelta(seconds=1))
        self.assertEqual(score_frequency([text]), 10)

        text.timestamp = datetime.now() - timedelta(seconds=31)
        self.assertEqual(score_frequency([text]), 5)

        text.timestamp = datetime.now() - timedelta(seconds=61)
        self.assertEqual(score_frequency([text]), 3)

        text.timestamp = datetime.now() - timedelta(seconds=91)
        self.assertEqual(score_frequency([text]), 0)

        text.timestamp = datetime.now() - timedelta(seconds=121)
        self.assertEqual(score_frequency([text]), -2)

        text.timestamp = datetime.now() - timedelta(seconds=151)
        self.assertEqual(score_frequency([text]), -4)

        text.timestamp = datetime.now() - timedelta(seconds=181)
        self.assertEqual(score_frequency([text]), -5)

        self.assertEqual(score_frequency([]), 0)

    def test_score_frequency_delta(self):
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(score_frequency_delta(prev_texts, curr_texts), 0)

        self.assertEqual(score_frequency_delta([], []), 0)

    def test_score_avg_length(self):
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
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2, msg="Hi", timestamp=datetime.now()),
        ]
        self.assertEqual(get_turn(texts, 1), 0.5)

        self.assertIsNone(get_turn([], -1))

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
        self.assertEqual(get_turn_delta(prev_texts, curr_texts, 1), 0)

        self.assertIsNone(get_turn_delta([], [], -1))

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
