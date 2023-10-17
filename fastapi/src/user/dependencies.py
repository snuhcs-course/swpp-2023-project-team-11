from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.database import DbConnector
from src.user.schemas import *
from src.user.exceptions import *
from src.user.models import EmailCode, Email, EmailVerification


def check_snu_email(req: EmailRequest) -> str:
    if req.email.endswith('@snu.ac.kr') is False:
        raise InvalidEmailException(req.email)
    
    return req.email


def check_verification_code(req: VerificationRequest, db: DbSession = Depends(DbConnector.get_db)) -> str:
    code = db.query(EmailCode).join(EmailCode.email).filter(Email.email == req.email).first()
    if code is None:
        raise InvalidEmailException(req.email)

    if code.code != req.code:
        raise InvalidEmailCodeException(req.email)

    return req.email

def check_verification_token(req: CreateUserRequest, db: DbSession = Depends(DbConnector.get_db)) -> CreateUserRequest:
    verification = db.query(EmailVerification).join(EmailVerification.email).filter(Email.email == req.email).first()
    if verification is None:
        raise InvalidEmailException(req.email)
    
    if verification.token != req.token:
        raise InvalidEmailTokenException(req.email)
    
    return req
