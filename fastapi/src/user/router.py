from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import get_session
from src.auth.models import Session
from src.auth.schemas import SessionResponse
from src.auth.service import create_session
from src.database import DbConnector
from src.user.dependencies import *
from src.user.schemas import *
from src.user import service


router = APIRouter(prefix="/user", tags=["user"])


@router.post("/email/code", response_model=None)
def create_verification_code(email: str = Depends(check_snu_email), db: DbSession = Depends(DbConnector.get_db)):
    code = service.create_verification_code(email, db)
    service.send_code_via_email(email, code)


@router.post("/email/verify", response_model=VerificationResponse)
def create_email_verification(email: str = Depends(check_verification_code), db: DbSession = Depends(DbConnector.get_db)):
    pass
    # token = service.create_verification(email, db)
    # return VerificationResponse(token=token)


@router.post("/sign_up", response_model=SessionResponse)
def create_user(req: CreateUserRequest = Depends(check_verification_token), db: DbSession = Depends(DbConnector.get_db)):
    pass
    # service.create_user(req.email, req.password, req.profile, db)
    # session_key = create_session(req.email)
    # return SessionResponse(access_token=session_key, token_type="bearer")


@router.get("/me", response_model=UserResponse)
def get_me(session: Session = Depends(get_session)):
    return session.user


@router.get("/all", response_model=List[UserResponse])
def get_all_users(session: Session = Depends(get_session), db: DbSession = Depends(DbConnector.get_db)):
    pass
    # return service.get_user_recommendations(session.user, db)
