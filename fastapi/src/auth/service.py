import base64
from datetime import datetime
import hmac
import hashlib
from sqlalchemy import delete, insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session as DbSession

from src.auth.exceptions import InvalidSessionException
from src.auth.models import Session
from src.constants import HASH_SECRET
from src.exceptions import InternalServerError


def get_user_by_session(session_key: int, db: DbSession) -> int:
    session = db.query(Session).filter(
        Session.session_key == session_key).first()
    if session is None:
        raise InvalidSessionException()

    return session.user_id


def create_session(user_id: int, db: DbSession) -> str:
    payload = bytes(str(user_id) + ' ' + str(datetime.now()), 'utf-8')
    signature = hmac.new(HASH_SECRET, payload,
                         digestmod=hashlib.sha256).digest()
    session_key = base64.urlsafe_b64encode(signature).decode('utf-8')

    try:
        db.execute(insert(Session).values(
            {"session_key": session_key, "user_id": user_id}))
    except IntegrityError:
        raise InternalServerError()  # Hash Collision
    else:
        db.commit()

    return session_key


def delete_session(session_key: str, db: DbSession):
    if db.scalar(delete(Session).where(Session.session_key == session_key).returning(Session.session_key)) != session_key:
        raise InvalidSessionException()

    db.commit()
