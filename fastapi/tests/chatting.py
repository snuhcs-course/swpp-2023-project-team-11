from datetime import timedelta
import unittest
from unittest.mock import patch, Mock

from sqlalchemy import insert, delete

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
    @inject_db
    def tearDownClass(cls, db: DbSession) -> None:
        teardown_user(db)
        db.commit()

    @inject_db
    def test_get_user_id(self, db: DbSession) -> None:
        valid_req = CreateChattingRequest(counterpart=self.email)
        invalid_req = CreateChattingRequest(counterpart=self.invalid)

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
    def test_chatting(self, db: DbSession):
        chatting = create_chatting(self.initiator_id, self.responder_id, db)
        chatting_id = chatting.id
        self.assertIsNotNone(chatting)
        self.assertEqual(chatting.is_approved, False)
        self.assertEqual(chatting.is_terminated, False)
        db.commit()

        self.assertEqual(get_all_chattings(self.initiator_id, True, db), [])
        self.assertEqual(len(get_all_chattings(
            self.initiator_id, False, db)), 1)
        self.assertEqual(len(get_all_chattings(
            self.responder_id, False, db)), 1)

        with self.assertRaises(ChattingNotExistException):
            approve_chatting(self.initiator_id, chatting_id, db)
        with self.assertRaises(ChattingNotExistException):
            approve_chatting(self.responder_id, -1, db)
        chatting = approve_chatting(self.responder_id, chatting_id, db)
        db.commit()

        self.assertEqual(chatting.id, chatting_id)
        self.assertEqual(
            len(get_all_chattings(self.initiator_id, True, db)), 1)
        self.assertEqual(len(get_all_chattings(
            self.initiator_id, False, db)), 0)

        intimacy = get_all_intimacies(self.initiator_id, None, None, None, db)
        self.assertEqual(len(intimacy), 1)
        intimacy = get_all_intimacies(self.responder_id, None, None, None, db)
        self.assertEqual(len(intimacy), 1)

        with self.assertRaises(ChattingNotExistException):
            terminate_chatting(-1, chatting_id, db)
        with self.assertRaises(ChattingNotExistException):
            terminate_chatting(self.initiator_id, -1, db)
        chatting = terminate_chatting(self.initiator_id, chatting_id, db)
        self.assertEqual(chatting.is_terminated, True)
        chatting = terminate_chatting(self.responder_id, chatting_id, db)
        db.commit()

    @inject_db
    def test_get_all_texts(self, db: DbSession):
        timestamp = datetime.now()

        chatting = create_chatting(self.initiator_id, self.responder_id, db)
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

        self.assertEqual(
            get_all_texts(-1, chatting.id, -1, None, None, db), [])
        self.assertEqual(get_all_texts(-1, None, -1, None, None, db), [])
        self.assertEqual(get_all_texts(
            self.initiator_id, -1, -1, None, None, db), [])
        self.assertEqual(
            len(get_all_texts(self.initiator_id, chatting.id, -1, None, None, db)), 5
        )
        self.assertEqual(
            len(get_all_texts(self.initiator_id, None, -1, None, None, db)), 5
        )
        self.assertEqual(
            len(get_all_texts(self.initiator_id,
                None, seq_ids[1], None, None, db)), 3
        )

        texts = get_all_texts(self.initiator_id, None, seq_ids[1], 2, None, db)
        self.assertEqual(len(texts), 2)
        self.assertEqual(texts[0].id, seq_ids[4])
        self.assertEqual(texts[1].id, seq_ids[3])

        texts = get_all_texts(
            self.initiator_id, None, seq_ids[1], None, timestamp + timedelta(milliseconds=3), db)
        self.assertEqual(len(texts), 2)
        self.assertEqual(texts[0].id, seq_ids[3])
        self.assertEqual(texts[1].id, seq_ids[2])

    @inject_db
    def test_get_all_intimacies(self, db: DbSession):
        chatting = create_chatting(self.initiator_id, self.responder_id, db)
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

        intimacies = get_all_intimacies(self.responder_id, None, None, None, db)
        self.assertEqual(len(intimacies), 0)
        
        intimacies = get_all_intimacies(self.initiator_id, None, None, None, db)
        self.assertEqual(len(intimacies), 5)
        self.assertEqual(intimacies[1].intimacy, 3)
        self.assertEqual(intimacies[3].intimacy, 1)
        self.assertEqual(intimacies[4].intimacy, 0)

        intimacies = get_all_intimacies(self.initiator_id, -1, None, None, db)
        self.assertEqual(len(intimacies), 0)

        intimacies = get_all_intimacies(self.initiator_id, None, 3, None, db)
        self.assertEqual(len(intimacies), 3)
        
        intimacies = get_all_intimacies(self.initiator_id, None, None, timestamp + timedelta(seconds=2.5), db)
        self.assertEqual(len(intimacies), 3)

    @patch("src.chatting.service.requests.post")  # patch for clova
    @inject_db
    def test_create_intimacy(self, mock_post, db: DbSession):
        papago_mock_response = Mock()
        clova_mock_response = Mock()
        papago_mock_response.status_code = 200
        clova_mock_response.status_code = 200
        clova_mock_response.text = json.dumps({'document': {'sentiment': 'positive', 'confidence': {'negative': 0.030769918, 'positive': 99.964096, 'neutral': 0.00513428}}, 'sentences': [
                                              {'content': 'translated text', 'offset': 0, 'length': 11, 'sentiment': 'positive', 'confidence': {'negative': 0.0018461951, 'positive': 0.99784577, 'neutral': 0.0003080568}, 'highlights': [{'offset': 0, 'length': 10}]}]})
        papago_mock_response.json.return_value = {'message': {'result': {
            'srcLangType': 'en', 'tarLangType': 'ko', 'translatedText': 'translated text'}}}
        mock_post.side_effect = [papago_mock_response, clova_mock_response]

        chatting = create_chatting(self.initiator_id, self.responder_id, db)
        chatting = approve_chatting(self.responder_id, chatting.id, db)

        timestamp = datetime.now()
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
        db.commit()

        intimacy = create_intimacy(self.initiator_id, chatting.id, db)
        self.assertEqual(intimacy.intimacy, 41.99933326082)

    @inject_db
    def test_get_topic(self, db: DbSession):
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
        self.assertIn(get_topics('C', 1, db)[0].topic, ["I'm so sad", "I'm so happy"])
        self.assertEqual(get_topics('B', 1, db)[0].topic, "I'm so mad")
        self.assertEqual(get_topics('A', 1, db)[0].topic, "I'm so good")
        #get_topics 함수의 return 값이 random 정렬 되었는지 확인
        test_list = get_topics('C', 2, db)
        self.assertNotEqual(test_list[0].topic, test_list[1].topic)
        self.assertEqual(len(test_list), 2)
        if test_list[0] == "I'm so sad":
            self.assertEqual(test_list[1].topic, "I'm so happy")
        elif test_list[0] == "I'm so happy":
            self.assertEqual(test_list[1].topic, "I'm so sad")

        #topic 개수보다 많은 개수를 요청할 경우
        self.assertEqual(len(get_topics('C', 3, db)), 2)
        self.assertEqual(len(get_topics('C', 4, db)), 2)
        self.assertEqual(len(get_topics('B', 5, db)), 1)

    def test_flatten_texts(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi I'm the text longer than 1000 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357,", timestamp=datetime.now()),
        ]
        expected_result = "Hello.Hi I'm the text longer than 1000 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214"
        result = flatten_texts(texts)
        self.assertEqual(result, expected_result)

    @unittest.skip("This test actually calls external API")
    def test_call_clova_api(self):
        with self.assertRaises(ExternalApiError):
            call_clova_api("")
        response = call_clova_api("I am Happy!")
        self.assertEqual(response.status_code, 200)

    @unittest.skip("This test actually calls external API")
    def test_call_papago_api(self):
        with self.assertRaises(ExternalApiError):
            call_papago_api("")
        response = call_papago_api("I am Happy!")
        self.assertEqual(response.status_code, 200)

    @patch("src.chatting.service.requests.post")
    def test_translate_text(self, mock_papago):
        mock_response = Mock()
        mock_response.status_code = 200
        data = {
            'message': {'result':
                        {'srcLangType': 'en', 'tarLangType': 'ko',
                            'translatedText': '나는 행복해!'}
                        }
        }

        mock_response.json.return_value = data
        mock_papago.return_value = mock_response

        response = translate_text("I'm so sad..")
        self.assertEqual(response, "나는 행복해!")

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

        response = get_sentiment("I am Happy!")
        self.assertEqual(response, 9.9933326082)

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
        result = get_frequency(texts)
        self.assertGreaterEqual(result, 39.9)
        self.assertLessEqual(result, 40.1)

        self.assertIsNone(get_frequency([]))

    def test_get_frequency_delta(self):
        self.assertIsNone(get_frequency_delta([], []))

    def test_score_frequency(self):
        text = Text(id=1, chatting_id=1, sender_id=1, msg="",
                    timestamp=datetime.now() - timedelta(seconds=1))
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
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
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
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        expected_result = 0
        result = score_avg_length_delta(prev_texts, curr_texts)
        self.assertEqual(result, expected_result)

    def test_get_turn(self):
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
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
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        self.assertEqual(get_turn_delta(prev_texts, curr_texts, 1), 0)

        self.assertIsNone(get_turn_delta([], [], -1))

    def test_score_turn(self):
        # Test case 1: Score turn rate of texts
        texts = [
            Text(
                id=1, chatting_id=1, sender_id=1, msg="Hello", timestamp=datetime.now()
            ),
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now()),
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
            Text(id=2, chatting_id=1, sender_id=2,
                 msg="Hi", timestamp=datetime.now())
        ]
        user_id = 1
        expected_result = 0
        result = score_turn_delta(prev_texts, curr_texts, user_id)
        self.assertEqual(result, expected_result)

    def test_set_weight(self):
        # Test case 1: Change weight of parameters
        my_profile = Profile(
            name="sangin", birth=date(1999, 5, 14), sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti="isfj", nation_code=82,
            foods=["korean_food", "thai_food"],
            movies=["horror", "action", "comedy"],
            locations=["up", "down"],
            hobbies=["soccer", "golf"]
        )

        your_profile1 = Profile(
            name="sangin", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti=None, nation_code=82,
            foods=["italian_food", "japan_food"], movies=["romance", "action"],
            locations=["up", "jahayeon"],
            hobbies=["golf"])

        your_profile2 = Profile(
            name="abdula", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti=None, nation_code=0,
            foods=["korean_food", "japan_food", "italian_food"], movies=["horror", "action", "romance"],
            locations=['up', "down", "jahayeon"],
            hobbies=["soccer"])

        your_profile3 = Profile(
            name="jiho", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            nation_code=1, mbti=None,
            foods=["japan_food"], movies=["action"],
            locations=["jahayeon"],
            hobbies=["golf", "soccer", "book"])

        me = User(user_id=0, verification_id=1, lang_id=1, salt="1", hash="1", profile=my_profile)
        you1 = User(user_id=1, verification_id=2, lang_id=2, salt="2", hash="2", profile=your_profile1)
        you2 = User(user_id=2, verification_id=3, lang_id=3, salt="3", hash="3", profile=your_profile2)
        you3 = User(user_id=3, verification_id=4, lang_id=4, salt="4", hash="4", profile=your_profile3)

        # 0.3780, 0.6324, 0.4082
        weight_1 = set_weight(me, you1)
        weight_2 = set_weight(me, you2)
        weight_3 = set_weight(me, you3)
        
        expected_weight1 = np.array([0.16, 0.18, 0.1, 0.18, 0.10, 0.18, 0.1])
        expected_weight2 = np.array([0.16, 0.16, 0.12, 0.16, 0.12, 0.16, 0.12])
        expected_weight3 = np.array([0.16, 0.17, 0.11, 0.17, 0.11, 0.17, 0.11])

        self.assertTrue(np.allclose(weight_1, expected_weight1))
        self.assertTrue(np.allclose(weight_2, expected_weight2))
        self.assertTrue(np.allclose(weight_3, expected_weight3))

    
    def test_get_mbti_f(self):
        my_profile = Profile(
            name="sangin", birth=date(1999, 5, 14), sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti="isfj", nation_code=82,
            foods=["korean_food", "thai_food"],
            movies=["horror", "action", "comedy"],
            locations=["up", "down"],
            hobbies=["soccer", "golf"]
        )
        your_profile = Profile(
            name="abdula", birth=date(1999, 5, 14)
            , sex="male", major="CLS", admission_year=2018, about_me="alpha male",
            mbti=None, nation_code=0,
            foods=["korean_food", "japan_food", "italian_food"], movies=["horror", "action", "romance"],
            locations=['up', "down", "jahayeon"],
            hobbies=["soccer"])
        
        my_user = User(user_id=0, verification_id=1, lang_id=1, salt="1", hash="1", profile=my_profile)
        your_user = User(user_id=1, verification_id=3, lang_id=3, salt="3", hash="3", profile=your_profile)
        self.assertEqual(get_mbti_f(my_user, your_user), 1)
        
        


if __name__ == "__main__":
    unittest.main()
