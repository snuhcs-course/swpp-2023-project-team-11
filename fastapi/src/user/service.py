from email.message import EmailMessage
import random
from smtplib import SMTP_SSL
from sqlalchemy import insert
from sqlalchemy.orm import Session as DbSession
from typing import List

from src.user.constants import *
from src.user.schemas import *
from src.user.models import *


def create_verification_code(email: str, db: DbSession) -> int:
    # 100000 ≤ code ≤ 999999
    code = 100000 + max(0, min(int(random.random() * 900000), 900000))

    email_id = db.scalar(insert(Email).values({"email": email}).returning(Email.id))
    db.execute(insert(EmailCode).values({
        "email_id": email_id,
        "code": code,
    }))
    db.commit()

    return code


def send_code_via_email(email: str, code: int) -> None:
    msg = EmailMessage()
    msg["Subject"] = "SNEK verification code"
    msg["From"] = MAIL_ADDRESS
    msg["To"] = email
    msg.set_content(f"Please enter your code: {code}")

    with SMTP_SSL(MAIL_SERVER, MAIL_PORT) as smtp:
        smtp.login(MAIL_ADDRESS, MAIL_PASSWORD)
        smtp.send_message(msg)


def create_verification(email: str) -> str:
    pass


def create_user(email: str, password: str, user: Profile):
    pass


def get_user_recommendations(user: Profile) -> List[Profile]:
    pass
