from fastapi import Depends

from src.auth.dependencies import oauth2_scheme
from src.user.schemas import *


def check_snu_email(req: EmailRequest) -> str:
    pass


def check_verification_code(req: VerificationRequest) -> str:
    pass


def check_verification_token(req: CreateUserRequest) -> CreateUserRequest:
    pass


def get_user(session_key: str = Depends(oauth2_scheme)) -> UserProfile:
    pass
