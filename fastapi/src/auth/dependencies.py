import base64
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
import hmac
import hashlib
from sqlalchemy.orm import Session as DbSession

from src.auth import service
from src.auth.exceptions import InvalidPasswordException
from src.constants import HASH_SECRET
from src.database import DbConnector
from src.user.service import get_user_by_email


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/sign_in")


def check_password(form: OAuth2PasswordRequestForm = Depends(),  db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidPasswordException`, `InvalidUserException`"""

    user = get_user_by_email(form.username, db)
    payload = bytes(form.password + user.salt, 'utf-8')
    signature = hmac.new(HASH_SECRET, payload,
                         digestmod=hashlib.sha256).digest()

    hash = bytes(user.hash, 'utf-8')
    if signature != base64.urlsafe_b64decode(hash):
        raise InvalidPasswordException()

    return user.user_id


def check_session(session_key: str = Depends(oauth2_scheme), db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidSessionException`"""

    return service.get_user_by_session(session_key, db)
