from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import check_session
from src.auth.exceptions import InvalidSessionException
from src.auth.schemas import SessionResponse
from src.auth.service import create_session, generate_session_key
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
    code = service.generate_code()
    service.create_verification_code(db, email, code)
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
    token = service.generate_token(req.email)
    service.create_verification(db, token, req.email, email_id)
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
    # Add foreign user's main language to available languages list
    if req.profile.nation_code != KOREA_CODE and req.main_language not in req.languages:
        req.languages.append(req.main_language)

    main_lang_id = service.get_language_by_name(db, req.main_language)
    salt, hash = service.generate_salt_hash(req.password)
    profile_id = service.create_profile(db, req.profile)
    service.create_user(db, req, verification_id, profile_id, main_lang_id, salt, hash)
    session_key = generate_session_key(profile_id)
    create_session(db, session_key, profile_id)
    db.commit()

    return SessionResponse(access_token=session_key, token_type="bearer")


@router.put(
    "/tag/create",
    description="Add user profile tags",
    summary="Add user tags",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(InvalidUserException())
    .add(InvalidFoodException())
    .add(InvalidHobbyException())
    .add(InvalidMovieException())
    .add(InvalidLocationException())
    .add(InvalidLanguageException())
    .build()
)
def update_user_tag_create(req: UpdateUserRequest, user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)) -> None:
    service.create_user_tag(db, user_id, req)
    db.commit()


@router.put(
    "/tag/delete",
    description="Remove user profile tags",
    summary="Remove user tags",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(InvalidUserException())
    .add(InvalidFoodException())
    .add(InvalidHobbyException())
    .add(InvalidMovieException())
    .add(InvalidLocationException())
    .add(InvalidLanguageException())
    .build()
)
def update_user_tag_delete(req: UpdateUserRequest, user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)) -> None:
    service.delete_user_tag(db, user_id, req)
    db.commit()


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
    user = service.get_user_by_id(db, user_id)
    return from_user(user)


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
    user = service.get_user_by_id(db, user_id)
    targets = service.get_target_users(db, user)
    return list(from_user(user) for user in service.sort_target_users(user, targets))
