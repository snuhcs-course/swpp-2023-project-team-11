from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.database import DbConnector
from src.user.schemas import *
from src.user.exceptions import *
from src.user.models import *
from src.user import service


def check_snu_email(req: EmailRequest) -> str:
    """Raises `InvalidEmailException`"""

    if req.email.endswith('@snu.ac.kr') is False:
        raise InvalidEmailException(req.email)

    return req.email


def check_verification_code(req: VerificationRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidEmailException`, `InvalidEmailCodeException`"""

    code = service.get_verification_code(db, req.email)
    if code.code != req.code:
        raise InvalidEmailCodeException()

    return code.email_id


def check_verification_token(req: CreateUserRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidEmailException`, `InvalidEmailTokenException`"""

    verification = service.get_verification(db, req.email)
    if verification.token != req.token:
        raise InvalidEmailTokenException()

    return verification.id
