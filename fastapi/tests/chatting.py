from datetime import timedelta
import unittest
from unittest.mock import patch, MagicMock, Mock

from sqlalchemy import insert, delete

from src.database import Base, DbConnector
from src.chatting.constants import *
from src.chatting.dependencies import *
from src.chatting.intimacy.calculator import *
from src.chatting.intimacy.factory import *
from src.chatting.intimacy.handler import *
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


class TestPapago(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.factory = PapagoServiceFactory(
            PAPAGO_CLIENT_ID, PAPAGO_CLIENT_SECRET)
        cls.korean_detection_factory = KoreanDetectionPapagoServiceFactory(
            PAPAGO_CLIENT_ID, PAPAGO_CLIENT_SECRET)
        cls.response = Mock()
        cls.response.json = Mock(
            return_value={"message": {"result": {"translatedText": "나는 행복해!"}}})

    @unittest.skip("Requires external API keys")
    def test_api(self):
        service = self.factory.create_service()
        translated = service.call("I am Happy!")
        # 평어체/경어체 논의 후 선택
        self.assertIn(translated, ["나는 행복해!", "난 행복해!"])
        with self.assertRaises(ExternalApiError):
            service.call("")
        with self.assertRaises(ExternalApiError):
            service.call("나는 행복해!")

    @unittest.skip("Requires external API keys")
    def test_korean_detection(self):
        service = self.korean_detection_factory.create_service()
        translated = service.call("I am Happy!")
        # 평어체/경어체 논의 후 선택
        self.assertIn(translated, ["나는 행복해!", "난 행복해!"])
        with self.assertRaises(KoreanTranslationException):
            service.call("나는 행복해!")

    def test_parser(self):
        parser = self.factory.create_parser()
        self.assertEqual(parser.parse(self.response), "나는 행복해!")


class TestClova(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.factory = ClovaServiceFactory(CLOVA_CLIENT_ID, CLOVA_CLIENT_SECRET)
        cls.response = Mock()
        cls.response.json = lambda: {"document": {
            "confidence": {"positive": 10, "negative": 3}}}

    @unittest.skip("Requires external API keys")
    def test_api(self):
        service = self.factory.create_service()
        sentiment = service.call("나는 슬퍼.")
        # the scope of sentiment [-5,10]
        self.assertGreaterEqual(sentiment, -5)
        self.assertLessEqual(sentiment, 0)
        with self.assertRaises(ClovaApiException):
            service.call("")

    def test_parser(self):
        parser = self.factory.create_parser()
        self.assertAlmostEqual(parser.parse(self.response), 0.7)


class TestHandler(unittest.TestCase):
    def setUp(self) -> None:
        self.valid = Mock()
        self.valid.status_code = 200
        self.korean = Mock()
        self.korean.status_code = 400
        self.korean.json = lambda: {'error': {'errorCode': 'N2MT05'}}
        self.unknown = Mock()
        self.unknown.status_code = 400
        self.unknown.json = lambda: {}

    def test_handler(self):
        factory = KoreanDetectionPapagoServiceFactory(
            PAPAGO_CLIENT_ID, PAPAGO_CLIENT_SECRET)
        handler = factory.create_handler()
        self.assertIsInstance(handler, KoreanDetectionPapagoHandler)
        handler.handle(self.valid)
        with self.assertRaises(KoreanTranslationException):
            handler.handle(self.korean)
        with self.assertRaises(HTTPException):
            handler.handle(self.unknown)


class TestService(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.caller = Mock()
        cls.handler = Mock()
        cls.parser = Mock()
        cls.response = Mock()
        cls.caller.request = Mock(return_value=cls.response)
        cls.handler.handle = Mock(return_value=None)
        cls.parser.parse = Mock(side_effect=lambda response: response.value)
        cls.response.value = 3

    def setUp(self) -> None:
        self.service = Mock()
        self.error_service = Mock()
        self.error_service.call = Mock(side_effect=ExternalApiError('call'))
        self.fallback = Mock()
        self.ignore_service = IgnoresEmptyTextService(
            self.service, self.fallback)
        self.suppress_service = SuppressErrorTextService(
            self.error_service, self.fallback)

    def test_base(self):
        service = BaseTextService(self.caller, self.handler, self.parser)
        self.assertEqual(service.call('hello'), 3)
        self.handler.handle.assert_called()

    def test_ignores_empty(self):
        self.ignore_service.call('')
        self.service.call.assert_not_called()
        self.fallback.assert_called()
        self.ignore_service.call('h')
        self.service.call.assert_called()

    def test_suppress(self):
        self.suppress_service.call('')
        self.fallback.assert_called()


class TestIntimacyCalculator(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        translation = Mock()
        translation.call = Mock()
        translation.call.return_value = '나는 행복해!'
        sentiment = Mock()
        sentiment.call = Mock()
        sentiment.call.return_value = 9.9933326082
        cls.calculator = IntimacyCalculator(translation, sentiment)

    def test_calculate(self):
        timestamp = datetime.now()
        curr_texts = [
            Text(id=1, proxy_id=0, sender_id=1,
                 msg="hello", timestamp=timestamp),
            Text(id=1, proxy_id=1, sender_id=1, msg="hello",
                 timestamp=timestamp - timedelta(seconds=1)),
            Text(id=1, proxy_id=2, sender_id=1, msg="you",
                 timestamp=timestamp - timedelta(seconds=2)),
            Text(id=1, proxy_id=3, sender_id=1, msg="what",
                 timestamp=timestamp - timedelta(seconds=3)),
            Text(id=1, proxy_id=4, sender_id=1, msg="bye",
                 timestamp=timestamp - timedelta(seconds=4)),
        ]
        recent_intimacy = Intimacy(
            id=1, user_id=1, chatting_id=1, intimacy=DEFAULT_INTIMACY, timestamp=timestamp)
        intimacy = self.calculator.calculate(
            1, curr_texts, [], recent_intimacy)
        self.assertEqual(intimacy, 37.25207554680268)

    def test_get_frequency(self):
        timestamp = datetime.now()
        texts = [
            Text(id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=1)),
            Text(id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=2)),
            Text(id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=3)),
            Text(id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="",
                 timestamp=timestamp - timedelta(seconds=8)),
        ]
        result = self.calculator.get_frequency(texts)
        self.assertGreaterEqual(result, 39.9)
        self.assertLessEqual(result, 40.1)

        self.assertIsNone(self.calculator.get_frequency([]))

    def test_get_frequency_delta(self):
        self.assertIsNone(self.calculator.get_frequency_delta([], []))

    def test_score_frequency(self):
        text = Text(id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="",
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
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(self.calculator.score_frequency_delta(
            prev_texts, curr_texts), 0)

        self.assertEqual(self.calculator.score_frequency_delta([], []), 0)

    def test_score_avg_length(self):
        texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        result = self.calculator.score_avg_length(texts)
        self.assertEqual(result, 0)

    def test_score_avg_length_delta(self):
        # Test case 1: Score average length delta of texts
        prev_texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        result = self.calculator.score_avg_length_delta(prev_texts, curr_texts)
        self.assertEqual(result, 0)

    def test_get_turn(self):
        texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
        ]
        self.assertEqual(self.calculator.get_turn(texts, 1), 0.5)

        self.assertIsNone(self.calculator.get_turn([], -1))

    def test_get_turn_delta(self):
        # Test case 1: Get turn delta of texts
        prev_texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(self.calculator.get_turn_delta(
            prev_texts, curr_texts, 1), 0)

        self.assertIsNone(self.calculator.get_turn_delta([], [], -1))

    def test_score_turn(self):
        texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
        ]
        result = self.calculator.score_turn(texts, 1)
        self.assertEqual(result, 10)

    def test_score_turn_delta(self):
        prev_texts = [
            Text(
                id=1, proxy_id=0, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            )
        ]
        curr_texts = [
            Text(id=2, proxy_id=0, chatting_id=1, sender_id=2,
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

        # check create_chatting throw exception when chatting already exists
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
                        "proxy_id": 0,
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
    def test_create_text(self, db: DbSession):
        chatting = create_chatting(db, self.initiator_id, self.responder_id)
        text = create_text(db, chatting.id, self.initiator_id, 0, "hello")
        self.assertEqual(text.proxy_id, 0)

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
                    {"topic_kor": "좋아용", "topic_eng": "I'm so good", "tag": "A"},
                    {"topic_kor": "화나요!!", "topic_eng": "I'm so mad", "tag": "B"},
                    {"topic_kor": "사랑해", "topic_eng": "I love you", "tag": "B"},
                    {"topic_kor": "슬퍼요...", "topic_eng": "I'm so sad", "tag": "C"},
                    {"topic_kor": "행복해요~!~!", "topic_eng": "I'm so happy", "tag": "C"},
                    {"topic_kor": "곧 종강이다~!", "topic_eng": "Jong-Gang", "tag": "C"}
                ]
            )
        )
        db.commit()

        topics_a = get_topics(db, "A", 1)
        topics_b = get_topics(db, "B", 2)
        topics_c = get_topics(db, "C", 5)

        # if get_topics get correct topics by tag

        for topic in topics_a:
            self.assertEqual(topic.topic_kor, "좋아용")
            self.assertEqual(topic.topic_eng, "I'm so good")
        for topic in topics_b:
            self.assertIn(topic.topic_kor, ["사랑해", "화나요!!"])
            self.assertIn(topic.topic_eng, ["I love you", "I'm so mad"])
        for topic in topics_c:
            self.assertIn(topic.topic_kor, ["슬퍼요...", "행복해요~!~!", "곧 종강이다~!"])
            self.assertIn(topic.topic_eng, [
                          "I'm so sad", "I'm so happy", "Jong-Gang"])

        # if it contains invalid tag or limit = 0
        self.assertEqual(len(get_topics(db, "D", 2)), 0)
        self.assertEqual(len(get_topics(db, "C", 0)), 0)

        # # get_topics 함수의 return 값이 random 정렬 되었는지 확인
        test_list = get_topics(db, 'B', 2)
        self.assertNotEqual(test_list[0].topic_kor, test_list[1].topic_kor)
        self.assertNotEqual(test_list[0].topic_eng, test_list[1].topic_eng)
        self.assertEqual(len(test_list), 2)
        if test_list[0].topic_eng == "I'm so mad":
            self.assertEqual(test_list[1].topic_kor, "사랑해")
            self.assertEqual(test_list[1].topic_eng, "I love you")
        elif test_list[0].topic_eng == "I love you":
            self.assertEqual(test_list[1].topic_kor, "화나요!!")
            self.assertEqual(test_list[1].topic_eng, "I'm so mad")

        # if requested more than number of topics
        self.assertEqual(len(get_topics(db, 'C', 3)), 3)
        self.assertEqual(len(get_topics(db, 'C', 4)), 3)
        self.assertEqual(len(get_topics(db, 'B', 5)), 2)


if __name__ == "__main__":
    unittest.main()
