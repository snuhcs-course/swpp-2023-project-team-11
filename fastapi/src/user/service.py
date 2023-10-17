from typing import List
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType
from starlette.responses import JSONResponse
from pydantic import BaseModel, EmailStr
from src.user.schemas import *
from constants import *
from src.database import DbConnector
from sqlalchemy.orm import Session as DbSession
from fastapi import Depends
from sqlalchemy import select
from src.user.models import EmailCode


def create_verification_code(email: str, db: DbSession = Depends(DbConnector.get_db)) -> int:

    #code = db.scalar(select(EmailCode).where(EmailCode.email == f'{email}')).code
    #return code
    pass


async def send_code_via_email(email: str, code: int):
    html = f"""<p> your code: {code}</p>"""
    conf = ConnectionConfig(
        MAIL_USERNAME=MAIL_USERNAME,
        MAIL_PASSWORD=MAIL_PASSWORD,
        MAIL_FROM=MAIL_FROM,
        MAIL_PORT=587,
        MAIL_SERVER="smtp.gmail.com",
        MAIL_STARTTLS=True,
        MAIL_SSL_TLS=False,
        USE_CREDENTIALS=True,
        VALIDATE_CERTS=True

    )
    message = MessageSchema(
        subject="your verification",
        recipients=[email],
        body=html,
        subtype=MessageType.html)

    fm = FastMail(conf)
    await fm.send_message(message)

    return JSONResponse(status_code=200, content={"message": "email has been sent"})


def create_verification(email: str) -> str:
    pass


def create_user(email: str, password: str, user: Profile):
    pass


def get_user_recommendations(user: Profile) -> List[Profile]:
    pass
