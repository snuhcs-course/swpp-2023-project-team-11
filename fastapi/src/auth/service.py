from fastapi import Depends
import hmac, hashlib
from sqlalchemy.orm import Session as DbSession
import time

import src.auth.models
from src.database import *
from src.auth.models import *

HASH_SECRET = ""


def create_session(email: str, db: DbSession = Depends(DbConnector.get_db)) -> str:
    secret = bytes(HASH_SECRET, 'utr-8')
    message = bytes(email + str(time.time()), 'utf-8')
    session_key = hmac.new(
        key=secret,
        msg=message,
        digestmod=hashlib.sha256
    ).digest()

    session = src.auth.models.Session(session_key=session_key)


    pass
    # return 'session-key'


def delete_session(session_key: str):
    pass
    # if session_key != 'session-key':
    #     raise HTTPException(status_code=401, detail="session does not exist")
