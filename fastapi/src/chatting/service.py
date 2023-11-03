from typing import List
from sqlalchemy import insert, update, desc, or_
from sqlalchemy.orm import Session as DbSession

from src.chatting.exceptions import *
from src.chatting.models import *
from src.user.models import Profile
import requests, json

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


def get_intimacy(user_id: int, chatting_id: int | None, db: DbSession) -> int:
    
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
    pass