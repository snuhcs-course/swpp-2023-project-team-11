from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import check_session
from src.chatting import service
from src.chatting.dependencies import *
from src.chatting.mapper import *
from src.chatting.schemas import *
from src.database import DbConnector

router = APIRouter(prefix="/chatting", tags=["chatting"])


@router.get("/", response_model=List[ChattingResponse])
def get_all_chattings(is_approved: bool, user_id: int = Depends(check_session),
                      db: DbSession = Depends(DbConnector.get_db)):
    return list(from_chatting(chatting) for chatting in service.get_all_chattings(user_id, is_approved, db))


@router.post("/", response_model=ChattingResponse)
def create_chatting(responder_id: int = Depends(check_counterpart), user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.create_chatting(user_id, responder_id, db)
    db.commit()
    return from_chatting(chatting)


@router.put("/", response_model=ChattingResponse)
def update_chatting(chatting_id: int, user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.approve_chatting(user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.delete("/", response_model=ChattingResponse)
def delete_chatting(chatting_id: int, user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.terminate_chatting(user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.get("/text", response_model=List[TextResponse])
def get_all_texts(seq_id: int = -1, limit: int | None = None, chatting_id: int | None = None, timestamp: datetime | None = None,
                  user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)):
    return list(from_text(text) for text in service.get_all_texts(user_id, chatting_id, seq_id, limit, timestamp, db))


@router.post("/intimacy", response_model=IntimacyResponse)
def create_intimacy(chatting_id: int, user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    intimacy = service.create_intimacy(user_id, chatting_id, db)
    db.commit()
    return from_intimacy(intimacy)


@router.get("/topic", response_model=TopicResponse)
def get_topic_recommendation(chatting_id: int, limit: int = 1, user_id: int = Depends(check_session),
                             db: DbSession = Depends(DbConnector.get_db)):
    intimacy = service.get_recent_intimacy(user_id, chatting_id, db)
    tag = service.get_tag_by_intimacy(intimacy)
    topics = service.get_topics(tag, limit, db)

    return list(from_topic(topic) for topic in topics)

# # TODO get intimacy endpoint 두 개 다 없애고 get chatting에 Intimacy 추가해서 보내기
# @router.get("/intimacy", response_model=IntimacyResponse)
# def get_intimacy(chatting_id: int, session: Session = Depends(get_session),
#                  db: DbSession = Depends(DbConnector.get_db)):
#     intimacy = service.get_recent_intimacy(user_id, chatting_id, db)
#     return from_intimacy(intimacy)

# @router.get("/intimacy/all", response_model=List[IntimacyResponse])
# def get_all_intimacy(chatting_id: int, session: Session = Depends(get_session),
#                  db: DbSession = Depends(DbConnector.get_db)):
#     intimacy = service.get_all_intimacies(user_id, chatting_id, None, None, db)
#     return list(from_intimacy(intimacy) for intimacy in intimacy)
