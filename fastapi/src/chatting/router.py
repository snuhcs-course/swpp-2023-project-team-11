from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import get_session
from src.auth.models import Session
from src.chatting import service
from src.chatting.dependencies import *
from src.chatting.mapper import *
from src.chatting.schemas import *
from src.database import DbConnector

router = APIRouter(prefix="/chatting", tags=["chatting"])


@router.get("/", response_model=List[ChattingResponse])
def get_all_chattings(is_approved: bool, session: Session = Depends(get_session),
                      db: DbSession = Depends(DbConnector.get_db)):
    return list(from_chatting(chatting) for chatting in service.get_all_chattings(session.user_id, is_approved, db))


@router.post("/", response_model=ChattingResponse)
def create_chatting(responder_id: int = Depends(get_user_id), session: Session = Depends(get_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.create_chatting(session.user_id, responder_id, db)
    db.commit()
    return from_chatting(chatting)


@router.put("/", response_model=ChattingResponse)
def update_chatting(chatting_id: int, session: Session = Depends(get_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.approve_chatting(session.user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.delete("/", response_model=ChattingResponse)
def delete_chatting(chatting_id: int, session: Session = Depends(get_session),
                    db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.terminate_chatting(session.user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.get("/text", response_model=List[TextResponse])
def get_all_texts(seq_id: int = -1, limit: int | None = None, chatting_id: int | None = None, timestamp: datetime | None = None,
                  session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    return list(from_text(text) for text in service.get_all_texts(session.user_id, chatting_id, seq_id, limit, timestamp, db))


# TODO HTTP Method get에서 post로 바꿔주세요
# TODO 이 함수 이름 create_intimacy로 바꿔주세요
@router.post("/intimacy", response_model=IntimacyResponse)
def create_intimacy(chatting_id: int, session: Session = Depends(get_session),
                 db: DbSession = Depends(DbConnector.get_db)):
    intimacy = service.create_intimacy(session.user_id, chatting_id, db)
    db.commit()
    # TODO Response Schema 만들어주세요
    return from_intimacy(intimacy)


@router.get("/topic", response_model=TopicResponse)
def get_topic_recommendation(chatting_id: int, session: Session = Depends(get_session),
                             db: DbSession = Depends(DbConnector.get_db)):
    # TODO response schema 만들어주세요
    topic = service.get_recommended_topic(session.user_id, chatting_id, db)
    return from_topic(topic)

# TODO Get intimacy endpoint 만들어주세요
@router.get("/intimacy", response_model=IntimacyResponse)
def get_intimacy(chatting_id: int, session: Session = Depends(get_session),
                 db: DbSession = Depends(DbConnector.get_db)):
    intimacy = service.get_intimacy(session.user_id, chatting_id, db)
    # TODO Response Schema 만들어주세요
    return from_intimacy(intimacy[-1])

@router.get("/intimacy/all", response_model=List[IntimacyResponse])
def get_all_intimacy(chatting_id: int, session: Session = Depends(get_session),
                 db: DbSession = Depends(DbConnector.get_db)):
    intimacy = service.get_intimacy(session.user_id, chatting_id, db)
    return list(from_intimacy(intimacy) for intimacy in intimacy)