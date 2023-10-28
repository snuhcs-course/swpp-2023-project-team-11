from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting import service
from src.chatting.schemas import *
from src.database import DbConnector


router = APIRouter(prefix="/chatting", tags=["chatting"])


@router.get("/", response_model=List[ChattingResponse])
def get_all_chattings(db: DbSession = Depends(DbConnector.get_db)):
    # TODO
    pass


@router.post("/", response_model=ChattingResponse)
def create_chatting(db: DbSession = Depends(DbConnector.get_db)):
    # TODO
    pass


@router.put("/", response_model=ChattingResponse)
def update_chatting(db: DbSession = Depends(DbConnector.get_db)):
    # TODO
    pass


@router.delete("/", response_model=ChattingResponse)
def delete_chatting(db: DbSession = Depends(DbConnector.get_db)):
    # TODO
    pass


@router.get("/text", response_model=List[TextResponse])
def get_all_texts(db: DbSession = Depends(DbConnector.get_db)):
    # TODO
    pass
