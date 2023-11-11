from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting.schemas import CreateChattingRequest
from src.database import DbConnector
from src.user.exceptions import InvalidUserException
from src.user.models import User, EmailVerification, Email


def get_user_id(req: CreateChattingRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    user = db.query(User).join(User.verification).join(EmailVerification.email).filter(Email.email == req.counterpart).first()
    if user is None:
        raise InvalidUserException()
    
    return user.user_id
