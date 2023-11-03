from typing import List
from sqlalchemy import insert, update, desc, or_
from sqlalchemy.orm import Session as DbSession

from src.chatting.exceptions import *
from src.chatting.models import *
from src.user.models import Profile
#import requests, json
from src.chatting.constants import *

def get_all_chattings(user_id: int, is_approved: bool, db: DbSession) -> List[Chatting]:
    query = db.query(Chatting).where(
            or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id)
        ).where(Chatting.is_approved == is_approved).order_by(Chatting.is_terminated, desc(Chatting.created_at))
    if is_approved is False:
        query = query.where(Chatting.is_terminated == False)
    return query.all()


def create_chatting(user_id: int, responder_id: int, db: DbSession) -> Chatting:
    return db.scalar(insert(Chatting).values({
        "initiator_id": user_id,
        "responder_id": responder_id,
        "created_at": datetime.now(),
    }).returning(Chatting))


def approve_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    chatting = db.scalar(update(Chatting).values(is_approved=True).where(Chatting.id == chatting_id).where(Chatting.responder_id == user_id).returning(Chatting))
    if chatting is None:
        raise InvalidChattingException()
    
    return chatting


def terminate_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    chatting = db.scalar(update(Chatting).values(is_terminated=True).where(Chatting.id == chatting_id).where(or_(Chatting.responder_id == user_id, Chatting.initiator_id == user_id)).returning(Chatting))
    if chatting is None:
        raise InvalidChattingException()
    
    return chatting


def get_all_texts(user_id: int, chatting_id: int | None, seq_id: int, limit: int | None, db: DbSession) -> List[Text]:
    query = db.query(Text).join(Text.chatting).where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id)).where(Text.id > seq_id).order_by(desc(Text.id))
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if limit is not None:
        query = query.limit(limit=limit)

    return query.all()


def get_intimacy(user_id: int, chatting_id: int | None, db: DbSession) -> float:
    
    recent_text = get_recent_texts(user_id, chatting_id, db)
    parsed_text = parse_recent_texts(recent_text)
    sentiment = calculate_sentiment_clova(parsed_text)
    
    user_profile = db.query(Profile).filter(Profile.id == user_id).first()
    

def get_recent_texts(user_id: int, chatting_id: int, db: DbSession) -> List[Text]:
    return db.query(Text).join(Text.chatting).filter(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id)).filter(Text.chatting_id == chatting_id).order_by(desc(Text.id)).limit(20).all()

def parse_recent_texts(texts: List[Text]) -> str:
    return ".".join(text.msg for text in texts)

def calculate_sentiment_clova(text:str) -> int:

    url="https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
    headers = {
    "X-NCP-APIGW-API-KEY-ID": CLOVA_CLIENT_ID,
    "X-NCP-APIGW-API-KEY": CLOVA_CLIENT_SECRET,
    "Content-Type": "application/json"
    }
    content = text
    data = {
            "content": content
    }
    response = requests.post(url, data=json.dumps(data), headers=headers)
    rescode = response.status_code
    if(rescode!=200):
        #print("Error Code:" + rescode)
        return 0
    
    confidence_text = response.json["document"]["confidence"]
    positive = response.json["document"]["confidence"]["positive"]
    negative = response.json["document"]["confidence"]["negative"]
    #positive[0~100] negative[0~100] 
    
    return positive-negative

def calculate_turn(user_id: int, texts: List[Text], chatting_id: int, db: DbSession) -> float:
    default = 50
    for text in texts:
        if text.sender_id == user_id:
            turn += 1
    
    rate = turn/len(texts)
    if 0.4 <= rate and rate <= 0.6 :
        return 100
    elif 0.3 <= rate and rate <= 0.7 : 
        return 80
    elif 0.2 <= rate and rate <= 0.8 : 
        return 60
    elif 0.1 <= rate and rate <= 0.9 : 
        return 40
    elif 0.0 <= rate and rate <= 1.0 :
        return 0
    else:
        return default

def get_recent_frequency(user_id: int, chatting_id:int, db:DbSession) -> float:
    default = 50
    texts = get_recent_texts(user_id, chatting_id, db)
    
    frequency = datetime.now() - texts[-1].timestamp
    seconds = frequency.seconds
    if 3600 <= seconds :
        return 0
    elif 3000 <= seconds :
        return 20
    elif 2400 <= seconds :
        return 40
    elif 1800 <= seconds :
        return 60
    elif 1200 <= seconds :
        return 80
    elif 600 <= seconds :
        return 100
    else:
        return default


def get_recent_length(user_id: int, chatting_id:int, db:DbSession) -> float:
    default = 50
    texts = get_recent_texts(user_id, chatting_id, db)
    avg_len = 0
    for text in texts:
        avg_len += len(text.msg)
    avg_len /= len(texts)
    
    if avg_len >= 40 : 
        return 100
    elif avg_len >= 30 :
        return 80
    elif avg_len >= 20 :
        return 60
    elif avg_len >= 10 :
        return 40
    elif avg_len >= 0 :
        return 20
    else:
        return default
