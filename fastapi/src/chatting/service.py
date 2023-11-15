from abc import ABCMeta, abstractclassmethod
import os
from typing import Dict, List, Tuple, Type

import json
import numpy as np
import requests
from sqlalchemy import insert, update, desc, or_, func
from sqlalchemy.orm import Session as DbSession

from src.chatting.constants import *
from src.chatting.exceptions import *
from src.chatting.models import *
from src.user.service import *


def get_chatting_by_id(db: DbSession, chatting_id: int) -> Chatting:
    chatting = db.query(Chatting).where(Chatting.id == chatting_id).first()
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def get_all_chattings(db: DbSession, user_id: int, is_approved: bool, limit: int | None = None) -> List[Chatting]:
    query = db.query(Chatting).where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id)).where(
        Chatting.is_approved == is_approved).order_by(Chatting.is_terminated, desc(Chatting.created_at))
    if is_approved is False:
        query = query.where(Chatting.is_terminated == False)
    if limit is not None:
        limit = min(1, limit)
        query = query.limit(limit)

    return query.all()


def create_chatting(db: DbSession, user_id: int, responder_id: int) -> Chatting:
    return db.scalar(
        insert(Chatting)
        .values(
            {
                "initiator_id": user_id,
                "responder_id": responder_id,
                "created_at": datetime.now(),
            }
        )
        .returning(Chatting)
    )


def approve_chatting(db: DbSession, user_id: int, chatting_id: int) -> Chatting:
    """Raises `ChattingNotExistException`"""

    chatting = db.scalar(
        update(Chatting)
        .values(is_approved=True)
        .where(Chatting.id == chatting_id)
        .where(Chatting.responder_id == user_id)
        .returning(Chatting)
    )
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def terminate_chatting(db: DbSession, user_id: int, chatting_id: int) -> Chatting:
    """Raises `ChattingNotExistException`"""

    chatting = db.scalar(
        update(Chatting)
        .values(is_terminated=True)
        .where(Chatting.id == chatting_id)
        .where(or_(Chatting.responder_id == user_id, Chatting.initiator_id == user_id))
        .returning(Chatting)
    )
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def get_all_texts(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
    seq_id: int = -1,
    limit: int | None = None,
    timestamp: datetime | None = None,
) -> List[Text]:
    query = (
        db.query(Text)
        .join(Text.chatting)
        .where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id))
        .where(Text.id > seq_id)
        .order_by(desc(Text.id))
    )
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if limit is not None:
        query = query.limit(limit=limit)
    if timestamp is not None:
        query = query.where(Text.timestamp <= timestamp)

    return query.all()


def get_all_intimacies(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
    limit: int | None = None,
    timestamp: datetime | None = None,
) -> List[Intimacy]:
    query = (
        db.query(Intimacy)
        .join(Intimacy.chatting)
        .where(Intimacy.user_id == user_id)
        .order_by(desc(Intimacy.id))
    )
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if limit is not None:
        query = query.limit(limit=limit)
    if timestamp is not None:
        # timestamp보다 과거의 것을 불러오는 것
        query = query.where(Intimacy.timestamp <= timestamp)

    return query.all()


def get_intimacy(db: DbSession, user_id: int, chatting_id: int) -> Tuple[Intimacy, bool]:
    intimacies = get_all_intimacies(db, user_id, chatting_id, limit=2)
    if len(intimacies) == 0:
        raise IntimacyNotExistException()

    return intimacies[0], len(intimacies) == 1


def get_recent_intimacy(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
) -> Intimacy | None:
    intimacies = get_all_intimacies(db, user_id, chatting_id, limit=1)
    if len(intimacies) == 0:
        return None
    return intimacies[0]


def create_intimacy(db: DbSession, user_id: int | List[int], chatting_id: int, intimacy: float = DEFAULT_INTIMACY) -> List[Intimacy]:
    if isinstance(user_id, int):
        user_id = [user_id]

    timestamp = datetime.now()
    return list(db.scalars(insert(Intimacy).values([{
        "user_id": user_id,
        "chatting_id": chatting_id,
        "intimacy": intimacy,
        "timestamp": timestamp,
    } for user_id in user_id]).returning(Intimacy)))


def get_topics(db: DbSession, tag: str, limit: int) -> List[Topic]:
    topics = db.query(Topic).where(Topic.tag == tag).order_by(
        func.random()).limit(limit).all()

    return topics


def intimacy_tag(intimacy: Intimacy | None) -> str:
    if intimacy is None or intimacy.intimacy <= 40:
        return "C"
    elif intimacy.intimacy <= 70:
        return "B"
    else:
        return "A"


class Client(ABCMeta):
    @abstractclassmethod
    def api_error(cls) -> HTTPException:
        pass

    @abstractclassmethod
    def api_url(cls) -> str:
        pass

    @abstractclassmethod
    def headers(cls) -> Dict[str, str]:
        pass

    @abstractclassmethod
    def data(cls, text: str) -> str | Dict[str, str]:
        pass

    @classmethod
    def post(cls, text: str) -> requests.Response:
        url = cls.api_url()
        headers = cls.headers()
        data = cls.data(text)
        response = requests.post(url, data=data, headers=headers)
        if response.status_code != 200:
            raise cls.api_error()
        return response


class TranslationClient(Client):
    @abstractclassmethod
    def parse_response(cls, response: requests.Response) -> str:
        """Return translated_text"""

    @classmethod
    def translate(cls, text: str) -> str:
        response = cls.post(text)
        return cls.parse_response(response)


class SentimentClient(Client):
    @abstractclassmethod
    def parse_response(cls, response: requests.Response) -> float:
        """Return sentiment"""

    @classmethod
    def get_sentiment(cls, text: str) -> float:
        response = cls.post(text)
        return cls.parse_response(response)


class PapagoClient(TranslationClient):
    API_URL: str = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation"
    CLIENT_ID: str = os.environ.get('SNEK_PAPAGO_CLIENT_ID')
    CLIENT_SECRET: str = os.environ.get('SNEK_PAPAGO_CLIENT_SECRET')

    @classmethod
    def api_error(cls) -> HTTPException:
        return PapagoApiException()

    @classmethod
    def api_url(cls) -> str:
        return cls.API_URL

    @classmethod
    def headers(cls) -> Dict[str, str]:
        return {
            "X-NCP-APIGW-API-KEY-ID": cls.CLIENT_ID,
            "X-NCP-APIGW-API-KEY": cls.CLIENT_SECRET,
        }

    @classmethod
    def data(cls, text: str) -> str | Dict[str, str]:
        if len(text) > 999:
            text = text[:999]
        return {"source": "auto", "target": "ko", "text": text}

    @classmethod
    def parse_response(cls, response: requests.Response) -> str:
        response = response.json()
        return response["message"]["result"]["translatedText"]


class ClovaClient(SentimentClient):
    API_URL: str = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
    CLIENT_ID: str = os.environ.get('SNEK_CLOVA_CLIENT_ID')
    CLIENT_SECRET: str = os.environ.get('SNEK_CLOVA_CLIENT_SECRET')

    @classmethod
    def api_error(cls) -> HTTPException:
        return ClovaApiException()

    @classmethod
    def api_url(cls) -> str:
        return cls.API_URL

    @classmethod
    def headers(cls) -> Dict[str, str]:
        return {
            "X-NCP-APIGW-API-KEY-ID": cls.CLIENT_ID,
            "X-NCP-APIGW-API-KEY": cls.CLIENT_SECRET,
            "Content-Type": "application/json",
        }

    @classmethod
    def data(cls, text: str) -> str | Dict[str, str]:
        return json.dumps({"content": text})

    @classmethod
    def parse_response(cls, response: requests.Response) -> float:
        data = json.loads(response.text)
        positive = data["document"]["confidence"]["positive"]
        negative = data["document"]["confidence"]["negative"]
        result = positive - negative
        if result >= 0:
            return result * 0.1
        else:
            return result * 0.05
        # positive[0~100] negative[0~100]


class IntimacyCalculator:
    __translation: Type[TranslationClient]
    __sentiment: Type[SentimentClient]

    def __init__(self, translation: Type[TranslationClient], sentiment: Type[SentimentClient]) -> None:
        self.__translation = translation
        self.__sentiment = sentiment

    def calculate(
        self,
        user_id: int,
        curr_texts: List[Text],
        prev_texts: List[Text],
        recent_intimacy: Intimacy,
        similarity: float | None,
        num_F: int | None,
    ) -> float:
        curr_translated = self.__translate_texts(curr_texts)
        sentiment = self.__get_sentiment(curr_translated)

        frequency = self.score_frequency(curr_texts)
        frequency_delta = self.score_frequency_delta(prev_texts, curr_texts)
        length = self.score_avg_length(curr_texts)
        length_delta = self.score_avg_length_delta(prev_texts, curr_texts)
        turn = self.score_turn(curr_texts, user_id)
        turn_delta = self.score_turn_delta(prev_texts, curr_texts, user_id)
        params = np.array([sentiment, frequency, frequency_delta,
                          length, length_delta, turn, turn_delta])

        weight = self.get_weight(similarity, num_F)
        new_intimacy: float = recent_intimacy.intimacy + \
            weight.dot(params.transpose())
        return max(0, min(100, new_intimacy))

    def __translate_texts(self, texts: List[Text]) -> str:
        text = '.'.join(text.msg for text in texts)
        if text == '':
            # No need to translate
            return text

        return self.__translation.translate(text)

    def __get_sentiment(self, text: str) -> float:
        if text == '':
            return 0

        return self.__sentiment.get_sentiment(text)

    @staticmethod
    def null_if_empty(func):
        """Decorator pattern"""

        def wrapper(texts: List[Text], *args, **kwargs) -> float | None:
            if len(texts) == 0:
                return None

            return func(texts, *args, **kwargs)

        return wrapper

    @staticmethod
    def get_delta(prev: float | None, curr: float | None) -> float | None:
        if prev is None or curr is None:
            return None
        return curr - prev

    @null_if_empty
    @staticmethod
    def get_frequency(texts: List[Text]) -> float | None:
        """An average seconds for 20 texts"""

        frequency = datetime.now() - texts[-1].timestamp
        seconds = frequency.seconds + frequency.microseconds / 1e6
        return seconds * 20 / len(texts)

    @staticmethod
    def get_frequency_delta(prev_text: List[Text], curr_text: List[Text]) -> float | None:
        return IntimacyCalculator.get_delta(
            IntimacyCalculator.get_frequency(prev_text),
            IntimacyCalculator.get_frequency(curr_text))

    @staticmethod
    def score_frequency(texts: List[Text]) -> int:
        seconds = IntimacyCalculator.get_frequency(texts)
        if seconds is None:
            return 0

        if 3600 <= seconds:
            return -5
        elif 3000 <= seconds:
            return -4
        elif 2400 <= seconds:
            return -2
        elif 1800 <= seconds:
            return 0
        elif 1200 <= seconds:
            return 3
        elif 600 <= seconds:
            return 5
        else:
            return 10

    @staticmethod
    def score_frequency_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
        seconds = IntimacyCalculator.get_frequency_delta(
            prev_texts, curr_texts)
        if seconds is None:
            return 0

        if 1800 <= seconds:
            return -5
        elif 1200 <= seconds:
            return -3
        elif 600 <= seconds:
            return -1
        elif -600 <= seconds:
            return 0
        elif -1200 <= seconds:
            return 3
        elif -1800 <= seconds:
            return 5
        else:
            return 10

    @null_if_empty
    @staticmethod
    def get_avg_length(texts: List[Text]) -> float | None:
        avg_len = 0
        for text in texts:
            avg_len += len(text.msg)
        avg_len /= len(texts)
        return avg_len

    @staticmethod
    def get_avg_length_delta(
        prev_texts: List[Text], curr_texts: List[Text]
    ) -> float | None:
        return IntimacyCalculator.get_delta(
            IntimacyCalculator.get_avg_length(prev_texts),
            IntimacyCalculator.get_avg_length(curr_texts))

    @staticmethod
    def score_avg_length(texts: List[Text]) -> int:
        avg_len = IntimacyCalculator.get_avg_length(texts)
        if avg_len is None:
            return 0

        if avg_len >= 30:
            return 10
        elif avg_len >= 20:
            return 7
        elif avg_len >= 10:
            return 4
        elif avg_len >= 5:
            return 0
        else:
            return -5

    @staticmethod
    def score_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
        avg_len = IntimacyCalculator.get_avg_length_delta(
            prev_texts, curr_texts)
        if avg_len is None:
            return 0

        if avg_len >= 15:
            return 10
        elif avg_len >= 10:
            return 5
        elif avg_len >= -10:
            return 0
        elif avg_len >= -20:
            return -3
        else:
            return -5

    # scope of rate[0,1]
    @null_if_empty
    @staticmethod
    def get_turn(texts: List[Text], user_id: int) -> float | None:
        """How many turns that the user took among provided texts"""

        turn = 0
        for text in texts:
            if text.sender_id == user_id:
                turn += 1

        rate = turn / len(texts)
        return rate

    # 작을수록 개선된 것(0.5에 가까워졌으므로)
    @staticmethod
    def get_turn_delta(
        prev_texts: List[Text], curr_texts: List[Text], user_id: int
    ) -> float | None:
        prev_rate = IntimacyCalculator.get_turn(prev_texts, user_id)
        curr_rate = IntimacyCalculator.get_turn(curr_texts, user_id)

        if prev_rate is None or curr_rate is None:
            return None

        return abs(curr_rate - 0.5) - abs(prev_rate - 0.5)

    @staticmethod
    def score_turn(texts: List[Text], user_id: int) -> int:
        rate = IntimacyCalculator.get_turn(texts, user_id)
        if rate is None:
            return 0

        if 0.4 <= rate <= 0.6:
            return 10
        elif 0.3 <= rate <= 0.7:
            return 5
        elif 0.2 <= rate <= 0.8:
            return 0
        elif 0.1 <= rate <= 0.9:
            return -3
        else:
            return -5

    @staticmethod
    def score_turn_delta(
        prev_texts: List[Text], curr_texts: List[Text], user_id: int
    ) -> int:
        rate = IntimacyCalculator.get_turn_delta(
            prev_texts, curr_texts, user_id)
        if rate is None:
            return 0

        if 0.3 <= rate:
            return -5
        elif 0.1 <= rate:
            return -3
        elif 0.0 <= rate:
            return 0
        else:
            return 10

    @staticmethod
    def get_weight(similarity: float | None = None, num_F: int | None = None) -> np.ndarray[float]:
        # Default
        if similarity is None or num_F is None:
            return np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])

        if similarity < 0.2:
            # sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta
            weight = np.array([0.1, 0.2, 0.1, 0.2, 0.1, 0.2, 0.1])
        elif similarity < 0.4:
            weight = np.array([0.1, 0.19, 0.11, 0.19, 0.11, 0.19, 0.11])
        elif similarity < 0.6:
            weight = np.array([0.1, 0.18, 0.12, 0.18, 0.12, 0.18, 0.12])
        elif similarity < 0.8:
            weight = np.array([0.1, 0.17, 0.13, 0.17, 0.13, 0.17, 0.13])
        else:
            weight = np.array([0.1, 0.16, 0.14, 0.16, 0.14, 0.16, 0.14])

        if num_F == 0:
            weight[0] += 0.03
            for i in range(1, 7):
                weight[i] -= 0.005
        elif num_F == 1:
            weight[0] += 0.06
            for i in range(1, 7):
                weight[i] -= 0.01
        elif num_F == 2:
            weight[0] += 0.09
            for i in range(1, 7):
                weight[i] -= 0.015

        return weight
