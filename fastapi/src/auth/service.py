import base64
from datetime import datetime
import hmac, hashlib
from sqlalchemy import insert, delete
from sqlalchemy.orm import Session as DbSession

from src.auth.constants import HASH_SECRET
from src.auth.exceptions import InvalidSessionException
from src.auth.models import Session


def create_session(user_id: int, db: DbSession) -> str:
    payload = bytes(str(user_id) + ' ' + str(datetime.now()), 'utf-8')
    signature = hmac.new(HASH_SECRET, payload, digestmod=hashlib.sha256).digest()
    session_key = base64.urlsafe_b64encode(signature).decode('utf-8')

    db.execute(insert(Session).values({
        "session_key": session_key,
        "user_id": user_id,
    }))
    db.commit()

    return session_key


def delete_session(session_key: str, db: DbSession):
    if db.scalar(delete(Session).where(Session.session_key == session_key).returning(Session.session_key)) != session_key:
        raise InvalidSessionException()

    db.commit()
