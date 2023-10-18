import base64
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import hmac, hashlib
from sqlalchemy.orm import Session as DbSession

from src.auth.exceptions import *
from src.auth.models import Session
from src.constants import HASH_SECRET
from src.database import DbConnector
from src.user.models import User, EmailVerification, Email


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/sign_in")


def check_password(form: OAuth2PasswordRequestForm = Depends(),  db: DbSession = Depends(DbConnector.get_db)) -> int:
    user = db.query(User).join(User.verification).join(EmailVerification.email).filter(Email.email == form.username).first()
    if user is None:
        raise InvalidUserException()

    payload = bytes(form.password + user.salt, 'utf-8')
    signature = hmac.new(HASH_SECRET, payload, digestmod=hashlib.sha256).digest()

    hash = bytes(user.hash, 'utf-8')
    if signature != base64.urlsafe_b64decode(hash):
        raise InvalidPasswordException()

    return user.user_id


def get_session(session_key: str = Depends(oauth2_scheme), db: DbSession = Depends(DbConnector.get_db)) -> Session:
    session = db.query(Session).filter(Session.session_key == session_key).first()
    if session is None:
        raise InvalidSessionException()
    
    return session
