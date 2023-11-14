from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import check_session
from src.auth.exceptions import InvalidSessionException
from src.auth.schemas import SessionResponse
from src.auth.service import create_session
from src.database import DbConnector
from src.exceptions import ErrorResponseDocsBuilder
from src.user.dependencies import *
from src.user.exceptions import *
from src.user.mapper import *
from src.user.schemas import *
from src.user import service


router = APIRouter(prefix="/user", tags=["user"])


@router.post(
    "/email/code",
    description="Request for email verification code",
    summary="Send code via email",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidEmailException())
    .build()
)
def create_verification_code(email: str = Depends(check_snu_email), db: DbSession = Depends(DbConnector.get_db)) -> None:
    code = service.create_verification_code(email, db)
    db.commit()

    service.send_code_via_email(email, code)


@router.post(
    "/email/verify",
    description="Verify email and create verifcation token",
    summary="Verify email code",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidEmailException())
    .add(InvalidEmailCodeException())
    .add(EmailInUseException())
    .build()
)
def create_email_verification(req: VerificationRequest, email_id: int = Depends(check_verification_code),
                              db: DbSession = Depends(DbConnector.get_db)) -> VerificationResponse:
    token = service.create_verification(req.email, email_id, db)
    db.commit()

    return VerificationResponse(token=token)


@router.post(
    "/sign_up",
    description="Create user profile and account",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidEmailException())
    .add(InvalidEmailTokenException())
    .add(InvalidFoodException())
    .add(InvalidHobbyException())
    .add(InvalidMovieException())
    .add(InvalidLocationException())
    .add(InvalidLanguageException())
    .add(EmailInUseException())
    .build()
)
def create_user(req: CreateUserRequest, verification_id: int = Depends(check_verification_token),
                db: DbSession = Depends(DbConnector.get_db)) -> SessionResponse:
    user_id = service.create_user(req, verification_id, db)
    session_key = create_session(user_id, db)
    db.commit()

    return SessionResponse(access_token=session_key, token_type="bearer")


@router.get(
    "/me",
    description="Get user profile",
    summary="Get user profile",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(InvalidUserException())
    .build()
)
def get_me(user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)) -> UserResponse:
    user = service.get_user_by_id(user_id, db)
    return from_user(user, db)


@router.get(
    "/all",
    description="Get user recommendations based on algorithm",
    summary="Recommend other users",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(InvalidUserException())
    .build()
)
def get_all_users(user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)) -> List[UserResponse]:
    user = service.get_user_by_id(user_id, db)
    targets = service.get_target_users(user, db)
    return list(from_user(user) for user in service.sort_target_users(user, targets))
