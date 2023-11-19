from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import oauth2_scheme, check_password
from src.auth.exceptions import *
from src.auth.schemas import *
from src.auth import service
from src.database import DbConnector
from src.exceptions import ErrorResponseDocsBuilder, InternalServerError
from src.user.exceptions import InvalidUserException


router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/sign_in",
    description="Sign in and create session",
    summary="Sign In",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidPasswordException())
    .add(InvalidUserException())
    .add(InternalServerError())
    .build()
)
def create_session(user_id: int = Depends(check_password), db: DbSession = Depends(DbConnector.get_db)) -> SessionResponse:
    session_key = service.generate_session_key(user_id)
    service.create_session(db, session_key, user_id)
    db.commit()

    return SessionResponse(access_token=session_key, token_type="bearer")


@router.delete(
    "/sign_out",
    description="Sign out and delete session",
    summary="Sign Out",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException()).build()
)
def delete_session(session_key: str = Depends(oauth2_scheme), db: DbSession = Depends(DbConnector.get_db)) -> None:
    service.delete_session(db, session_key)
    db.commit()
