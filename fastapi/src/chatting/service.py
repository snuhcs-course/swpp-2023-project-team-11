from typing import List

import json
import numpy as np
import requests
from sqlalchemy import insert, update, desc, or_, func
from sqlalchemy.orm import Session as DbSession

from src.chatting.constants import *
from src.chatting.exceptions import *
from src.chatting.models import *
from src.user.service import *


def get_all_chattings(user_id: int, is_approved: bool, db: DbSession) -> List[Chatting]:
    query = (
        db.query(Chatting)
        .where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id))
        .where(Chatting.is_approved == is_approved)
        .order_by(Chatting.is_terminated, desc(Chatting.created_at))
    )
    if is_approved is False:
        query = query.where(Chatting.is_terminated == False)

    return query.all()


def create_chatting(user_id: int, responder_id: int, db: DbSession) -> Chatting:
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


def approve_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
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

    timestamp = datetime.now()
    # FIXME insert_intimacy로 따로 만들기
    db.execute(
        insert(Intimacy).values(
            [
                {
                    "user_id": user_id,
                    "chatting_id": chatting_id,
                    "intimacy": DEFAULT_INTIMACY,
                    "timestamp": timestamp,
                },
                {
                    "user_id": chatting.initiator_id,
                    "chatting_id": chatting_id,
                    "intimacy": DEFAULT_INTIMACY,
                    "timestamp": timestamp,
                },
            ]
        )
    )

    return chatting


def terminate_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
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
    user_id: int,
    chatting_id: int | None,
    seq_id: int,
    limit: int | None,
    timestamp: datetime | None,
    db: DbSession,
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


def get_recent_intimacy(
    user_id: int,
    chatting_id: int | None,
    db: DbSession
) -> Intimacy | None:
    intimacies = get_all_intimacies(user_id, chatting_id, 1, None, db)
    if len(intimacies) == 0:
        return None
    return intimacies[0]


def get_all_intimacies(
    user_id: int,
    chatting_id: int | None,
    limit: int | None,
    timestamp: datetime | None,
    db: DbSession,
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


def create_intimacy(user_id: int, chatting_id: int, db: DbSession) -> Intimacy:
    """Raises `ChattingNotExistException`, `ClovaApiError`, `PapagoApiError`"""

    # Previous 20 texts from chatting
    curr_texts = get_all_texts(user_id, chatting_id, -1, 20, None, db)

    # Get Intimacy info
    intimacies = get_all_intimacies(user_id, chatting_id, 2, None, db)
    if len(intimacies) == 0:
        raise IntimacyNotExistException()
    recent_intimacy = intimacies[0]

    if len(intimacies) > 1:
        prev_texts = get_all_texts(
            user_id, chatting_id, -1, 20, recent_intimacy.timestamp, db)
    else:
        # we cannot calculate delta value with only one intimacy (which is definitely a default value)
        prev_texts = []

    chatting = db.query(Chatting).where(Chatting.id == chatting_id).first()
    if chatting is None:
        raise ChattingNotExistException()
    new_intimacy_value = calculate_intimacy(
        curr_texts, prev_texts, recent_intimacy, user_id, chatting.initiator, chatting.responser)
    new_intimacy = db.scalar(
        insert(Intimacy)
        .values(
            {
                "user_id": user_id,
                "chatting_id": chatting_id,
                "intimacy": new_intimacy_value,
                "timestamp": datetime.now(),
            }
        )
        .returning(Intimacy)
    )

    return new_intimacy


def get_topics(tag: str, limit: int, db: DbSession) -> List[Topic]:
    topics = db.query(Topic).where(Topic.tag == tag).order_by(
        func.random()).limit(limit).all()

    return topics


def get_tag_by_intimacy(intimacy: Intimacy | None) -> str:
    if intimacy is None or intimacy.intimacy <= 40:
        return "C"
    elif intimacy.intimacy <= 70:
        return "B"
    else:
        return "A"


def calculate_intimacy(
    curr_texts: List[Text],
    prev_texts: List[Text],
    recent_intimacy: Intimacy,
    user_id: int,
    initiator: User,
    responser: User
) -> int:
    """Raises `ClovaApiError`, `PapagoApiError`"""

    # sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta
    if len(prev_texts) == 0:
        weight = np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])
    else:
        weight = set_weight(initiator, responser)

    curr_flatten: str = flatten_texts(curr_texts)
    curr_translated: str = translate_text(curr_flatten)
    sentiment = get_sentiment(curr_translated)

    frequency = score_frequency(curr_texts)
    length = score_avg_length(curr_texts)
    turn = score_turn(curr_texts, user_id)

    frequency_delta = score_frequency_delta(prev_texts, curr_texts)
    length_delta = score_avg_length_delta(prev_texts, curr_texts)
    turn_delta = score_turn_delta(prev_texts, curr_texts, user_id)

    parameters = np.array(
        [sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta])
    new_intimacy_value: int = recent_intimacy.intimacy + \
        weight.dot(parameters.transpose())
    return max(0, min(100, new_intimacy_value))


def flatten_texts(texts: List[Text]) -> str:
    # len(text.msg)<50 이하인 것만 join
    result = '.'.join(text.msg for text in texts)
    if len(result) > 999:
        result = result[:999]
    return result


def call_clova_api(text) -> requests.Response:
    """Raises `ClovaApiException`"""

    headers = {
        "X-NCP-APIGW-API-KEY-ID": CLOVA_CLIENT_ID,
        "X-NCP-APIGW-API-KEY": CLOVA_CLIENT_SECRET,
        "Content-Type": "application/json",
    }
    data = json.dumps({"content": text})

    response = requests.post(CLOVA_API_URL, data=data, headers=headers)
    if response.status_code != 200:
        raise ClovaApiException()
    return response


def call_papago_api(text) -> requests.Response:
    """Raises `PapagoApiException`"""

    headers = {
        "X-NCP-APIGW-API-KEY-ID": PAPAGO_CLIENT_ID,
        "X-NCP-APIGW-API-KEY": PAPAGO_CLIENT_SECRET,
    }
    data = {"source": "auto", "target": "ko", "text": text}
    response = requests.post(PAPAGO_API_URL, data=data, headers=headers)
    if response.status_code != 200:
        raise PapagoApiException()
    return response


def translate_text(text: str) -> str:
    """Raises PapagoApiException"""

    if text == '':
        # No need to translate
        return text

    response = call_papago_api(text)
    parsed_response = response.json()
    return parsed_response["message"]["result"]["translatedText"]


def get_sentiment(text: str) -> int:
    """Raises ClovaApiException"""

    if text == '':
        return 0

    response = call_clova_api(text)
    parsed_data = json.loads(response.text)
    positive = parsed_data["document"]["confidence"]["positive"]
    negative = parsed_data["document"]["confidence"]["negative"]
    result = positive - negative
    if result >= 0:
        return result * 0.1
    else:
        return result * 0.05
    # positive[0~100] negative[0~100]


def null_if_empty(func):
    """Decorator pattern"""

    def wrapper(texts: List[Text], *args, **kwargs) -> float | None:
        if len(texts) == 0:
            return None

        return func(texts, *args, **kwargs)

    return wrapper


def get_delta(prev: float | None, curr: float | None) -> float | None:
    """Decorator pattern"""

    if prev is None or curr is None:
        return None
    return curr - prev


@null_if_empty
def get_frequency(texts: List[Text]) -> float | None:
    """An average seconds for 20 texts"""

    frequency = datetime.now() - texts[-1].timestamp
    seconds = frequency.seconds + frequency.microseconds / 1e6
    return seconds * 20 / len(texts)


def get_frequency_delta(prev_text: List[Text], curr_text: List[Text]) -> float | None:
    return get_delta(get_frequency(prev_text), get_frequency(curr_text))


def score_frequency(texts: List[Text]) -> int:
    seconds = get_frequency(texts)
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


def score_frequency_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
    seconds = get_frequency_delta(prev_texts, curr_texts)
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
def get_avg_length(texts: List[Text]) -> float | None:
    avg_len = 0
    for text in texts:
        avg_len += len(text.msg)
    avg_len /= len(texts)
    return avg_len


def get_avg_length_delta(
    prev_texts: List[Text], curr_texts: List[Text]
) -> float | None:
    return get_delta(get_avg_length(prev_texts), get_avg_length(curr_texts))


def score_avg_length(texts: List[Text]) -> int:
    avg_len = get_avg_length(texts)
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


def score_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
    avg_len = get_avg_length_delta(prev_texts, curr_texts)
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
def get_turn(texts: List[Text], user_id: int) -> float | None:
    """How many turns that the user took among provided texts"""

    turn = 0
    for text in texts:
        if text.sender_id == user_id:
            turn += 1

    rate = turn / len(texts)
    return rate


# 작을수록 개선된 것(0.5에 가까워졌으므로)
def get_turn_delta(
    prev_texts: List[Text], curr_texts: List[Text], user_id: int
) -> float | None:
    prev_rate = get_turn(prev_texts, user_id)
    curr_rate = get_turn(curr_texts, user_id)

    if prev_rate is None or curr_rate is None:
        return None

    return abs(curr_rate - 0.5) - abs(prev_rate - 0.5)


def score_turn(texts: List[Text], user_id: int) -> int:
    rate = get_turn(texts, user_id)
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


def score_turn_delta(
    prev_texts: List[Text], curr_texts: List[Text], user_id: int
) -> int:
    rate = get_turn_delta(prev_texts, curr_texts, user_id)
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


def set_weight(initiator: User, responser: User) -> np.ndarray[float]:
    # get user similarity
    similarity = get_similarity(get_user_dataframe(
        initiator), get_user_dataframe(responser))

    # set weight
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

    # set weight according to mbti F, revise sentiment weight
    num_F = get_mbti_f(initiator, responser)

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
