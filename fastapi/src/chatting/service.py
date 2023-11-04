import numpy as np
from typing import List
from sqlalchemy import insert, update, desc, or_
from sqlalchemy.orm import Session as DbSession
from src.chatting.exceptions import *
from src.chatting.models import *
from src.user.models import Profile
import requests, json
from src.chatting.constants import *


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

    default_intimacy = 36.5
    #Set default intimacy(유저별)
    db.execute(
        insert(Intimacy)
        .values({
            "user_id": user_id,
            "chatting_id": chatting_id,
            "intimacy": default_intimacy,
            "timestamp": datetime.now(),
        })
    )
    chatting = db.scalar(
        update(Chatting)
        .values(is_approved=True)
        .where(Chatting.id == chatting_id)
        .where(Chatting.responder_id == user_id)
        .returning(Chatting)
    )
    if chatting is None:
        raise InvalidChattingException()

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
    user_id: int, chatting_id: int | None, seq_id: int, limit: int | None, db: DbSession
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

    return query.all()


def get_intimacy(user_id: int, chatting_id: int | None, db: DbSession) -> float:
    # sentiment, frequency, frequency_delta, length, length_delta, turn, turn_delta
    default_weight = np.array([0.1, 0.3, 0, 0.3, 0, 0.3, 0])
    weight = np.array([0.1, 0.2, 0.1, 0.2, 0.1, 0.2, 0.1])

    curr_texts = parse_recent_texts(get_recent_texts(user_id, chatting_id, DbSession))

    #every parameters we use
    sentiment = calculate_sentiment_clova(curr_texts)
    frequency = score_frequency(curr_texts)
    length = score_avg_length(curr_texts)
    turn = score_turn(curr_texts)
    frequency_delta = length_delta = turn_delta = 0

    user_intimacy_info = (
        db.query(Intimacy)
        .filter(Intimacy.user_id == user_id, Intimacy.chatting_id == chatting_id)
        .first()
    )
    #if intimacy value is initial value
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
   
        prev_texts = parse_recent_texts(get_previous_texts(user_id, chatting_id,timestamp, DbSession))
        frequency_delta = score_frequency_delta(prev_texts, curr_texts)
        length_delta = score_avg_length_delta(prev_texts, curr_texts)
        turn_delta = score_turn_delta(prev_texts, curr_texts, user_id)
    
        parameter_arr = np.array([sentiment, frequency, frequency_delta, 
                             length, length_delta, turn, turn_delta])
    
        intimacy = weight.dot(parameter_arr.transpose())
    
    #Update

    user_intimacy_info.intimacy += intimacy
    if user_intimacy_info.intimacy > 100:
        user_intimacy_info.intimacy = 100
    elif user_intimacy_info.intimacy < 0:
        user_intimacy_info.intimacy = 0
    
    return intimacy


def get_recent_texts(user_id: int, chatting_id: int, db: DbSession) -> List[Text]:
    return (
        db.query(Text)
        .join(Text.chatting)
        .filter(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id))
        .filter(Text.chatting_id == chatting_id)
        .order_by(desc(Text.id))
        .limit(20)
        .all()
    )


def get_previous_texts(
    user_id: int, chatting_id: int, timestamp: DateTime, db: DbSession
) -> List[Text]:
    return (
        db.query(Text)
        .join(Text.chatting)
        .filter(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id))
        .filter(Text.chatting_id == chatting_id)
        .filter(Text.timestamp < timestamp)
        .order_by(desc(Text.id))
        .limit(20)
        .all()
    )


def parse_recent_texts(texts: List[Text]) -> str:
    return ".".join(text.msg for text in texts)


def calculate_sentiment_clova(text: str) -> int:
    url = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
    headers = {
        "X-NCP-APIGW-API-KEY-ID": CLOVA_CLIENT_ID,
        "X-NCP-APIGW-API-KEY": CLOVA_CLIENT_SECRET,
        "Content-Type": "application/json",
    }
    content = text
    data = {"content": content}
    response = requests.post(url, data=json.dumps(data), headers=headers)
    rescode = response.status_code

    if rescode != 200:
        # print("Error Code:" + rescode)
        return 0

    parsed_data = json.loads(response.text)
    positive = parsed_data["document"]["confidence"]["positive"]
    negative = parsed_data["document"]["confidence"]["negative"]
    # positive[0~100] negative[0~100]

    return positive - negative


def get_frequency(texts: List[Text]) -> float:
    default = 50
    frequency = datetime.now() - texts[-1].timestamp
    seconds = frequency.seconds
    return seconds


def get_frequency_delta(prev_text: List(Text), curr_text: List(Text)) -> float:
    return get_frequency(curr_text) - get_frequency(prev_text)


def score_frequency(texts: List[Text]) -> int:
    seconds = get_frequency(texts)
    default = 0
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
    elif 0 <= seconds:
        return 10
    else:
        return default


def score_frequency_delta(prev_texts: List[Text], curr_texts: List[Text]) -> float:
    seconds = get_frequency_delta(prev_texts, curr_texts)
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


def score_avg_length(texts: List[Text]) -> int:
    avg_len = get_avg_length(texts)
    if avg_len >= 30:
        return 10
    elif avg_len >= 20:
        return 7
    elif avg_len >= 10:
        return 4
    elif avg_len >= 5:
        return 0
    elif avg_len >= 0:
        return -5
    else:
        return 0


def score_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> int:
    default = 0
    avg_len = get_avg_length_delta(prev_texts, curr_texts)
    if avg_len >= 15:
        return 10
    elif avg_len >= 10:
        return 5
    elif avg_len >= -10:
        return 0
    elif avg_len >= -20:
        return -3
    elif avg_len < -20:
        return -5
    else:
        return default


def get_avg_length(texts: List[Text]) -> float:
    avg_len = 0
    for text in texts:
        avg_len += len(text.msg)
    avg_len /= len(texts)
    return avg_len


def get_avg_length_delta(prev_texts: List[Text], curr_texts: List[Text]) -> float:
    return get_avg_length(curr_texts) - get_avg_length(prev_texts)


# scope of rate[0,1]
def get_turn(texts: List[Text], user_id: int) -> float:
    default = 50
    turn = 0
    for text in texts:
        if text.sender_id == user_id:
            turn += 1

    rate = turn / len(texts)
    return rate


def get_turn_delta(
    prev_texts: List[Text], curr_texts: List[Text], user_id: int
) -> float:
    # 작을수록 개선된 것(0.5에 가까워졌으므로)
    return np.abs(get_turn(curr_texts, user_id)-0.5) - np.abs(get_turn(prev_texts, user_id)-0.5)


def score_turn(texts: List[Text], user_id: int) -> int:
    rate = get_turn(texts, user_id)
    default = 0
    if 0.4 <= rate and rate <= 0.6:
        return 10
    elif 0.3 <= rate and rate <= 0.7:
        return 5
    elif 0.2 <= rate and rate <= 0.8:
        return 0
    elif 0.1 <= rate and rate <= 0.9:
        return -3
    elif 0.0 <= rate and rate <= 1.0:
        return -5
    else:
        return default


def score_turn_delta(
    prev_texts: List[Text], curr_texts: List[Text], user_id: int
) -> int:
    rate = get_turn_delta(prev_texts, curr_texts, user_id)
    default = 0
    if 0.3 <= rate :
        return -5
    elif 0.1 < rate :
        return -3
    elif 0.0 < rate :
        return 0
    elif -0.5<= rate :
        return 10
    else:
        return default

def change_weight(weight: List[float]) -> List[float]:
    
    return weight