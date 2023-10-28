from typing import List
from sqlalchemy import insert, update, desc
from sqlalchemy.orm import Session as DbSession

from src.chatting.exceptions import *
from src.chatting.models import *


def get_all_chattings(user_id: int, is_approved: bool, db: DbSession) -> List[Chatting]:
    return db.query(Chatting).where(
            Chatting.initiator_id == user_id or Chatting.responder_id == user_id
        ).where(
            Chatting.is_approved == is_approved
        ).order_by(
            desc(Chatting.created_at)).all()


def create_chatting(user_id: int, responder_id: int, db: DbSession) -> Chatting:
    return db.scalar(insert(Chatting).values({
        "initiator_id": user_id,
        "responder_id": responder_id,
        "created_at": datetime.now(),
    }).returning(Chatting))


def approve_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    chatting = db.scalar(update(Chatting).values(is_approved=True).where(Chatting.id == chatting_id).where(Chatting.responder_id == user_id))
    if chatting is None:
        raise InvalidChattingException()
    
    return chatting


def terminate_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    chatting = db.scalar(update(Chatting).values(is_terminated=True).where(Chatting.id == chatting_id).where(Chatting.responder_id == user_id or Chatting.initiator_id == user_id))
    if chatting is None:
        raise InvalidChattingException()
    
    return chatting


def get_all_texts(user_id: int, chatting_id: int | None, seq_id: int, limit: int | None, db: DbSession) -> List[Text]:
    query = db.query(Text).join(Text.chatting).where(Chatting.initiator_id == user_id or Chatting.responder_id == user_id).where(Text.id > seq_id).order_by(desc(Text.id))
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if limit is not None:
        query = query.limit(limit=limit)

    return query.all()
