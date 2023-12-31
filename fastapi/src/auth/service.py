import base64
from datetime import datetime
import hmac
import hashlib

from sqlalchemy import select, delete, insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Session as DbSession

from src.auth.exceptions import InvalidSessionException
from src.auth.models import Session
from src.constants import HASH_SECRET
from src.exceptions import InternalServerError


class AuthQuery:
    @staticmethod
    def get_session_by_key(session_key: str):
        return select(Session).filter(Session.session_key == session_key)


def get_session_by_key(db: DbSession, session_key: str) -> Session:
    """Raises `InvalidSessionException`"""

    session = db.scalar(AuthQuery.get_session_by_key(session_key))
    if session is None:
        raise InvalidSessionException()

    return session


async def async_get_session_by_key(db: AsyncSession, session_key: str) -> Session:
    """Raises `InvalidSessionException`"""

    session = await db.scalar(AuthQuery.get_session_by_key(session_key))
    if session is None:
        raise InvalidSessionException()

    return session


def create_session(db: DbSession, session_key: str, user_id: int):
    """Raises `InternalServerError`"""

    try:
        db.execute(insert(Session).values(
            {"session_key": session_key, "user_id": user_id}))
    except IntegrityError:
        raise InternalServerError()  # Hash Collision


def delete_session(db: DbSession, session_key: str):
    """Raises `InvalidSessionException`"""

    if db.scalar(delete(Session).where(Session.session_key == session_key).returning(Session.session_key)) != session_key:
        raise InvalidSessionException()


def generate_session_key(user_id: int) -> str:
    payload = bytes('<' + str(user_id) + '>' + str(datetime.now()), 'utf-8')
    signature = hmac.new(HASH_SECRET, payload,
                         digestmod=hashlib.sha256).digest()
    return base64.urlsafe_b64encode(signature).decode('utf-8')
