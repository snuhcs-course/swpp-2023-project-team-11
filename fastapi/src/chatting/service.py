import random
from typing import List

import json
import numpy as np
import requests
from sqlalchemy import insert, update, desc, or_
from sqlalchemy.orm import Session as DbSession
import urllib.request, urllib.parse

from src.chatting.constants import *
from src.chatting.exceptions import *
from src.chatting.models import *
from src.exceptions import ExternalApiError


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
    chatting = db.scalar(
        update(Chatting)
        .values(is_approved=True)
        .where(Chatting.id == chatting_id)
        .where(Chatting.responder_id == user_id)
        .returning(Chatting)
    )
    if chatting is None:
        raise InvalidChattingException()

    timestamp = datetime.now(),
    db.execute(
        insert(Intimacy)
        .values([
            {
                "user_id": user_id,
                "chatting_id": chatting_id,
                "intimacy": DEFAULT_INTIMACY,
                "is_default": True,
                "timestamp": timestamp,
            },
            {
                "user_id": chatting.initiator_id,
                "chatting_id": chatting_id,
                "intimacy": DEFAULT_INTIMACY,
                "is_default": True,
                "timestamp": timestamp,
            },
        ])
    )

    return chatting


def terminate_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    chatting = db.scalar(
        update(Chatting)
        .values(is_terminated=True)
        .where(Chatting.id == chatting_id)
        .where(or_(Chatting.responder_id == user_id, Chatting.initiator_id == user_id))
        .returning(Chatting)
    )
    if chatting is None:
        raise InvalidChattingException()

    return chatting


def get_all_texts(
        user_id: int, chatting_id: int | None, seq_id: int, limit: int | None, timestamp: datetime | None, db: DbSession
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


def get_recommended_topic(user_id: int, chatting_id: int, db: DbSession) -> str:
    intimacy = get_intimacy(user_id, chatting_id, db)
    tag = get_tag(intimacy)
    return get_topic(tag, db)


def get_tag(intimacy: float) -> str:
    if intimacy <= 40:
        return "C"
    elif intimacy <= 70:
        return "B"
    else:
        return "A"


def get_topic(tag: str, db: DbSession) -> str:
    topics = db.query(Topic).where(Topic.tag == tag).all()
    idx = random.randint(0, len(topics)-1)
    return topics[idx].topic


def get_intimacy(user_id: int, chatting_id: int, db: DbSession) -> float:
    # sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta
    default_weight = np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])
    weight = np.array([0.1, 0.2, 0.1, 0.2, 0.1, 0.2, 0.1])

    # Previous 20 texts from chatting
    curr_texts: List[Text] = get_all_texts(user_id, chatting_id, -1, 20, None, db)
    curr_flatten: str = flatten_texts(curr_texts)
    curr_translated: str = translate_text(curr_flatten)

    # every parameter we use
    sentiment: int = get_sentiment(curr_translated)
    frequency: int = score_frequency(curr_texts)
    frequency_delta = 0
    length: int = score_avg_length(curr_texts)
    length_delta = 0
    turn = score_turn(curr_texts, user_id)
    turn_delta = 0

    # Get Intimacy info
    user_intimacy_info = (
        db.query(Intimacy)
        .filter_by(user_id=user_id, chatting_id=chatting_id)
        .order_by(Intimacy.timestamp.desc())
        .first()
    )

    if user_intimacy_info is None:
        print("user_intimacy_info is None")
        return 0

    # if intimacy value is initial value
    is_default = user_intimacy_info.is_default
    timestamp = user_intimacy_info.timestamp
    user_intimacy_info.timestamp = datetime.now()

    if is_default:
        user_intimacy_info.is_default = False

        ## todo: get timestamp from db, update intimacy

        parameter_arr = np.array([sentiment, frequency, frequency_delta,
                                  length, length_delta, turn, turn_delta])
        intimacy = default_weight.dot(parameter_arr.transpose())

    else:
        prev_texts: List[Text] = get_all_texts(user_id, chatting_id, -1, 20, timestamp, db)
        frequency_delta = score_frequency_delta(prev_texts, curr_texts)
        length_delta = score_avg_length_delta(prev_texts, curr_texts)
        turn_delta = score_turn_delta(prev_texts, curr_texts, user_id)

        parameter_arr = np.array([sentiment, frequency, frequency_delta,
                                  length, length_delta, turn, turn_delta])

        intimacy = weight.dot(parameter_arr.transpose())

    # Update

    intimacy += user_intimacy_info.intimacy
    if intimacy > 100:
        intimacy = 100
    elif intimacy < 0:
        intimacy = 0
    user_intimacy_info.intimacy = intimacy
    return intimacy


def flatten_texts(texts: List[Text]) -> str:
    return ".".join(text.msg for text in texts)


def translate_text(text: str) -> str:
    # Request
    data = ("source=auto&target=ko&text=" + urllib.parse.quote(text)).encode('utf-8')
    request = urllib.request.Request(PAPAGO_API_URL)
    request.add_header("X-NCP-APIGW-API-KEY-ID", PAPAGO_CLIENT_ID)
    request.add_header("X-NCP-APIGW-API-KEY", PAPAGO_CLIENT_SECRET)
    response = urllib.request.urlopen(request, data=data)
    if response.getcode() != 200:
        raise ExternalApiError("translation")

    # Parse Response
    decoded_response = response.read().decode('utf-8')
    return json.loads(decoded_response)['message']['result']['translatedText']


def get_sentiment(text: str) -> int:
    headers = {
        "X-NCP-APIGW-API-KEY-ID": CLOVA_CLIENT_ID,
        "X-NCP-APIGW-API-KEY": CLOVA_CLIENT_SECRET,
        "Content-Type": "application/json"
    }

    response = requests.post(CLOVA_API_URL, data=json.dumps({"content": text}), headers=headers)
    if response.status_code != 200:
        raise ExternalApiError("sentimental")

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
    def wrapper(texts: List[Text], *args, **kwargs) -> float | None:
        if len(texts) == 0:
            return None

        return func(texts, *args, **kwargs)

    return wrapper


def get_delta(prev: float | None, curr: float | None) -> float | None:
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


def get_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> float | None:
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


def change_weight(weight: List[float]) -> List[float]:
    """It is not used now, but will be used by applying cosine similarity between users to adjust weights"""
    return weight
