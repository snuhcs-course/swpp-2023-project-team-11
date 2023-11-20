from datetime import timedelta
import unittest
from unittest.mock import patch, MagicMock, Mock

from sqlalchemy import insert, delete

from src.database import Base, DbConnector
from src.chatting.dependencies import *
from src.chatting.models import *
from src.chatting.service import *
from tests.utils import *


class TestDependencies(unittest.TestCase):
    email = "test@snu.ac.kr"

    @patch('src.chatting.dependencies.get_user_by_email')
    @InjectMock('db')
    def test_check_counterpart(self, mock_get_user_by_email: MagicMock, db: DbSession):
        dummy_user = Mock()
        dummy_user.user_id = 1
        mock_get_user_by_email.side_effect = lambda db, email: dummy_user

        req = CreateChattingRequest(counterpart=self.email)

        self.assertEqual(check_counterpart(req, db), dummy_user.user_id)



class TestPapagoClient(unittest.TestCase):
    client = PapagoClient

    @unittest.skip("Requires external API keys")
    def test_translate_text(self):
        translated = self.client.translate("I am Happy!")
        #평어체/경어체 논의 후 선택
        self.assertEqual(translated, "나는 행복해!")
        with self.assertRaises(ExternalApiError):
            self.client.translate("")


class MockClient(Client):
    @classmethod
    def api_error(cls) -> HTTPException:
        return ExternalApiError()

    @classmethod
    def api_url(cls) -> str:
        return ''

    @classmethod
    def headers(cls) -> Dict[str, str]:
        return {}

    @classmethod
    def data(cls, text: str) -> str | Dict[str, str]:
        return ''

    @classmethod
    def post(cls, text: str) -> requests.Response:
        return requests.Response()


class MockTranslationClient(TranslationClient, MockClient):
    @classmethod
    def parse_response(cls, response: requests.Response) -> str:
        ''

    @classmethod
    def translate(cls, text: str) -> str:
        raise cls.api_error()


class MockSentimentClient(SentimentClient, MockClient):
    @classmethod
    def parse_response(cls, response: requests.Response) -> float:
        ''

    @classmethod
    def get_sentiment(cls, text: str) -> float:
        raise cls.api_error()


class TestIgnoresEmptyInputTranslationClient(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.client = IgnoresEmptyInputTranslationClient(MockTranslationClient)

    def test_translate_text(self):
        self.assertEqual(self.client.translate(''), '')
        with self.assertRaises(ExternalApiError):
            self.client.translate('I am Happy!')


class TestClovaClient(unittest.TestCase):
    client = ClovaClient
    @unittest.skip("Requires external API keys")
    def test_get_sentiment(self):
        sentiment = self.client.get_sentiment("I am sad.")
        sentiment = self.client.get_sentiment("")
        #the scope of sentiment [-5,10] 
        self.assertGreaterEqual(sentiment, -5)
        self.assertLessEqual(sentiment, 10)
        with self.assertRaises(ClovaApiException):
            self.client.get_sentiment("")


class TestIgnoresEmptyInputSentimentClient(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.client = IgnoresEmptyInputSentimentClient(MockSentimentClient)

    def test_get_sentiment(self):
        self.assertEqual(self.client.get_sentiment(''), 0)
        with self.assertRaises(ExternalApiError):
            self.client.get_sentiment('I am Happy!')


class TestIntimacyCalculator(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        translation = Mock()
        translation.translate = Mock()
        translation.translate.return_value = '나는 행복해!'
        sentiment = Mock()
        sentiment.get_sentiment = Mock()
        sentiment.get_sentiment.return_value = 9.9933326082
        cls.calculator = IntimacyCalculator(translation, sentiment)

    def test_calculate(self):
        timestamp = datetime.now()
        curr_texts = [
            Text(id=1, sender_id=1, msg="hello", timestamp=timestamp),
            Text(id=1, sender_id=1, msg="hello",
                 timestamp=timestamp - timedelta(seconds=1)),
            Text(id=1, sender_id=1, msg="you",
                 timestamp=timestamp - timedelta(seconds=2)),
            Text(id=1, sender_id=1, msg="what",
                 timestamp=timestamp - timedelta(seconds=3)),
            Text(id=1, sender_id=1, msg="bye",
                 timestamp=timestamp - timedelta(seconds=4)),
        ]
        recent_intimacy = Intimacy(
            id=1, user_id=1, chatting_id=1, intimacy=DEFAULT_INTIMACY, timestamp=timestamp)
        intimacy = self.calculator.calculate(
            1, curr_texts, [], recent_intimacy)
        self.assertEqual(intimacy, 37.49933326082)

    def test_get_frequency(self):
        timestamp = datetime.now()
        texts = [
            Text(id=1, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=1)),
            Text(id=1, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=2)),
            Text(id=1, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=3)),
            Text(id=1, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=8)),
        ]
        result = self.calculator.get_frequency(texts)
        self.assertGreaterEqual(result, 39.9)
        self.assertLessEqual(result, 40.1)

        self.assertIsNone(self.calculator.get_frequency([]))

    def test_get_frequency_delta(self):
        self.assertIsNone(self.calculator.get_frequency_delta([], []))

    def test_score_frequency(self):
        text = Text(id=1, chatting_id=1, sender_id=1, msg="",
                    timestamp=datetime.now() - timedelta(seconds=1))
        self.assertEqual(self.calculator.score_frequency([text]), 10)

        text.timestamp = datetime.now() - timedelta(seconds=31)
        self.assertEqual(self.calculator.score_frequency([text]), 5)

        text.timestamp = datetime.now() - timedelta(seconds=61)
        self.assertEqual(self.calculator.score_frequency([text]), 3)

        text.timestamp = datetime.now() - timedelta(seconds=91)
        self.assertEqual(self.calculator.score_frequency([text]), 0)

        text.timestamp = datetime.now() - timedelta(seconds=121)
        self.assertEqual(self.calculator.score_frequency([text]), -2)

        text.timestamp = datetime.now() - timedelta(seconds=151)
        self.assertEqual(self.calculator.score_frequency([text]), -4)

        text.timestamp = datetime.now() - timedelta(seconds=181)
        self.assertEqual(self.calculator.score_frequency([text]), -5)

        self.assertEqual(self.calculator.score_frequency([]), 0)

    def test_score_frequency_delta(self):
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(self.calculator.score_frequency_delta(
            prev_texts, curr_texts), 0)

        self.assertEqual(self.calculator.score_frequency_delta([], []), 0)

    def test_score_avg_length(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        result = self.calculator.score_avg_length(texts)
        self.assertEqual(result, 0)

    def test_score_avg_length_delta(self):
        # Test case 1: Score average length delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        result = self.calculator.score_avg_length_delta(prev_texts, curr_texts)
        self.assertEqual(result, 0)

    def test_get_turn(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
        ]
        self.assertEqual(self.calculator.get_turn(texts, 1), 0.5)

        self.assertIsNone(self.calculator.get_turn([], -1))

    def test_get_turn_delta(self):
        # Test case 1: Get turn delta of texts
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(self.calculator.get_turn_delta(
            prev_texts, curr_texts, 1), 0)

        self.assertIsNone(self.calculator.get_turn_delta([], [], -1))

    def test_score_turn(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
        ]
        result = self.calculator.score_turn(texts, 1)
        self.assertEqual(result, 10)

    def test_score_turn_delta(self):
        prev_texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        result = self.calculator.score_turn_delta(prev_texts, curr_texts, 1)
        self.assertEqual(result, 0)

    def test_get_weight(self):
        weight = self.calculator.get_weight()
        self.assertTrue(
            np.all(weight == np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])))
        weight = self.calculator.get_weight(0.1, 2)
        self.assertTrue(np.all(weight == np.array(
            [0.19, 0.185, 0.085, 0.185, 0.085, 0.185, 0.085])))


class TestDb(unittest.TestCase):
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
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        teardown_user(db)
        db.commit()

    @inject_db
    def tearDown(self, db: DbSession) -> None:
        db.execute(delete(Topic))
        db.execute(delete(Intimacy))
        db.execute(delete(Text))
        db.execute(delete(Chatting))
        db.commit()
      
    
    @inject_db
    def test_create_chatting(self, db: DbSession):
        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        self.assertIsNotNone(chatting)
        self.assertEqual(chatting.initiator_id, self.initiator_id)
        self.assertEqual(chatting.responder_id, self.responder_id)
        self.assertEqual(chatting.is_approved, False)
        self.assertEqual(chatting.is_terminated, False)
        db.commit()

        #check create_chatting throw exception when chatting already exists
        with self.assertRaises(ChattingAlreadyExistException):
            create_chatting(db, self.initiator_id, self.responder_id)
      
    @inject_db
    def test_chatting(self, db: DbSession):
        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        chatting_id = chatting.id
        self.assertIsNotNone(chatting)
        self.assertEqual(chatting.is_approved, False)
        self.assertEqual(chatting.is_terminated, False)
        db.commit()

        self.assertEqual(get_chatting_by_id(db, chatting_id), chatting)
        self.assertEqual(get_all_chattings(db, self.initiator_id, True), [])
        self.assertEqual(len(get_all_chattings(
            db, self.initiator_id, False)), 1)
        self.assertEqual(len(get_all_chattings(
            db, self.responder_id, False)), 1)
        with self.assertRaises(ChattingNotExistException):
            get_chatting_by_id(db, -1)

        with self.assertRaises(ChattingNotExistException):
            approve_chatting(db, self.initiator_id, chatting_id)
        with self.assertRaises(ChattingNotExistException):
            approve_chatting(db, self.responder_id, -1)
        chatting = approve_chatting(db, self.responder_id, chatting_id)
        db.commit()

        self.assertEqual(
            len(get_all_chattings(db, self.initiator_id, True)), 1)
        self.assertEqual(len(get_all_chattings(
            db, self.initiator_id, False)), 0)

        with self.assertRaises(ChattingNotExistException):
            terminate_chatting(db, -1, chatting_id)
        with self.assertRaises(ChattingNotExistException):
            terminate_chatting(db, self.initiator_id, -1)
        chatting = terminate_chatting(db, self.initiator_id, chatting_id)
        self.assertEqual(chatting.is_terminated, True)
        chatting = terminate_chatting(db, self.responder_id, chatting_id)
        db.commit()

    @inject_db
    def test_get_all_texts(self, db: DbSession):
        timestamp = datetime.now()

        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        seq_ids = list(
            db.scalars(
                insert(Text)
                .values(list(
                    {
                        "chatting_id": chatting.id,
                        "sender_id": self.initiator_id,
                        "msg": "hello",
                        "timestamp": timestamp + timedelta(milliseconds=i),
                    } for i in range(5)
                ))
                .returning(Text.id)
            )
        )
        db.commit()

        self.assertEqual(get_all_texts(db, -1, chatting.id), [])
        self.assertEqual(get_all_texts(db, -1), [])
        self.assertEqual(get_all_texts(db, self.initiator_id, -1), [])
        self.assertEqual(
            len(get_all_texts(db, self.initiator_id, chatting.id)), 5)
        self.assertEqual(len(get_all_texts(db, self.initiator_id)), 5)
        self.assertEqual(
            len(get_all_texts(db, self.initiator_id, seq_id=seq_ids[1])), 3)

        texts = get_all_texts(db, self.initiator_id,
                              seq_id=seq_ids[1], limit=2)
        self.assertEqual(len(texts), 2)
        self.assertEqual(texts[0].id, seq_ids[4])
        self.assertEqual(texts[1].id, seq_ids[3])

        texts = get_all_texts(
            db, self.initiator_id, seq_id=seq_ids[1], timestamp=timestamp + timedelta(milliseconds=3))
        self.assertEqual(len(texts), 2)
        self.assertEqual(texts[0].id, seq_ids[3])
        self.assertEqual(texts[1].id, seq_ids[2])

    @inject_db
    def test_get_intimacy(self, db: DbSession):
        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        timestamp = datetime.now()
        db.execute(
            insert(Intimacy)
            .values(list({
                "user_id": self.initiator_id,
                "chatting_id": chatting.id,
                "intimacy": i,
                "timestamp": timestamp + timedelta(seconds=i)
            } for i in range(5)))
        )

        intimacies = get_all_intimacies(db, self.responder_id)
        self.assertEqual(len(intimacies), 0)
        intimacies = get_all_intimacies(db, self.initiator_id)
        self.assertEqual(len(intimacies), 5)
        self.assertEqual(intimacies[1].intimacy, 3)
        self.assertEqual(intimacies[3].intimacy, 1)
        self.assertEqual(intimacies[4].intimacy, 0)
        intimacies = get_all_intimacies(db, self.initiator_id, -1)
        self.assertEqual(len(intimacies), 0)
        intimacies = get_all_intimacies(db, self.initiator_id, limit=3)
        self.assertEqual(len(intimacies), 3)
        intimacies = get_all_intimacies(
            db, self.initiator_id, timestamp=timestamp + timedelta(seconds=2.5))
        self.assertEqual(len(intimacies), 3)

        intimacy, is_default = get_intimacy(db, self.initiator_id, chatting.id)
        self.assertEqual(intimacy.intimacy, 4)
        self.assertFalse(is_default)
        with self.assertRaises(IntimacyNotExistException):
            get_intimacy(db, self.responder_id, chatting.id)
        with self.assertRaises(IntimacyNotExistException):
            get_intimacy(db, self.initiator_id, -1)

        intimacy = get_recent_intimacy(db, self.initiator_id, chatting.id)
        self.assertEqual(intimacy.intimacy, 4)
        intimacy = get_recent_intimacy(db, self.responder_id, chatting.id)
        self.assertIsNone(intimacy)

    @inject_db
    def test_create_intimacy(self, db: DbSession):
        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        intimacies = create_intimacy(
            db, [self.initiator_id, self.responder_id], chatting.id)
        self.assertEqual(len(intimacies), 2)

    @inject_db
    def test_get_topic(self, db: DbSession):
        db.execute(
            insert(Topic).values(
                [
                    {"topic": "I'm so good", "tag": "A", "is_korean": False},
                    {"topic": "I'm so mad", "tag": "B", "is_korean": False},
                    {"topic": "I'm so sad", "tag": "C", "is_korean": False},
                    {"topic": "I'm so happy", "tag": "C", "is_korean": False},
                    {"topic": "곧 종강이다~!", "tag": "C", "is_korean": True}
                ]
            )
        )
        db.commit()
        self.assertIn(get_topics(db, 'C', 1, False)[0].topic, [
                      "I'm so sad", "I'm so happy"])
        self.assertEqual(get_topics(db, 'C', 1, True)[0].topic, "곧 종강이다~!")
        self.assertEqual(len(get_topics(db, 'A', 1, True)), 0)
        self.assertEqual(len(get_topics(db, 'B', 1, True)), 0)


        self.assertEqual(get_topics(db, 'B', 1, False)[0].topic, "I'm so mad")
        self.assertEqual(get_topics(db, 'A', 1, False)[0].topic, "I'm so good")
        # get_topics 함수의 return 값이 random 정렬 되었는지 확인
        test_list = get_topics(db, 'C', 2, False)
        self.assertNotEqual(test_list[0].topic, test_list[1].topic)
        self.assertEqual(len(test_list), 2)
        if test_list[0] == "I'm so sad":
            self.assertEqual(test_list[1].topic, "I'm so happy")
        elif test_list[0] == "I'm so happy":
            self.assertEqual(test_list[1].topic, "I'm so sad")

        # topic 개수보다 많은 개수를 요청할 경우
        self.assertEqual(len(get_topics(db, 'C', 3, False)), 2)
        self.assertEqual(len(get_topics(db, 'C', 4, False)), 2)
        self.assertEqual(len(get_topics(db, 'B', 5, False)), 1)


if __name__ == "__main__":
    unittest.main()
