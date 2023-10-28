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
def get_all_chattings(is_approved: bool, session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    return list(from_chatting(chatting) for chatting in service.get_all_chattings(session.user_id, is_approved, db))


@router.post("/", response_model=ChattingResponse)
def create_chatting(responder_id: int = Depends(get_user_id), session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.create_chatting(session.user_id, responder_id, db)
    db.commit()
    return from_chatting(chatting)


@router.put("/", response_model=ChattingResponse)
def update_chatting(chatting_id: int, session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.approve_chatting(session.user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.delete("/", response_model=ChattingResponse)
def delete_chatting(chatting_id: int, session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    chatting = service.terminate_chatting(session.user_id, chatting_id, db)
    db.commit()
    return from_chatting(chatting)


@router.get("/text", response_model=List[TextResponse])
def get_all_texts(seq_id: int = 0, limit: int | None = None, chatting_id: int | None = None, session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    return list(from_text(text) for text in service.get_all_texts(session.user_id, chatting_id, seq_id, limit, db))
