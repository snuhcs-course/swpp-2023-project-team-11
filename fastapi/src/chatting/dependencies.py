from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting.schemas import CreateChattingRequest
from src.database import DbConnector
from src.user.service import get_user_by_email


def check_counterpart(req: CreateChattingRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    return get_user_by_email(req.counterpart, db).user_id
