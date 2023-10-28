from datetime import date

from sqlalchemy import insert, delete, select
from sqlalchemy.orm import Session as DbSession

from src.user.models import *


def setup_user(db: DbSession, email: str) -> int:
    token = "token"
    salt = "salt"
    hash = "TgnJJnmbbfKJLmZiArqCc61kGYrZlvlfsatsFfKlQK4="
    name = "SNEK"

    email_id = db.scalar(insert(Email).values({"email": email}).returning(Email.id))
    verification_id = db.scalar(
        insert(EmailVerification).values({
            "token": token,
            "email_id": email_id,
        })
        .returning(EmailVerification.id)
    )
    lang_id = db.scalar(select(Language.id).where(Language.name == "Korean"))
    if lang_id is None:
        lang_id = db.scalar(insert(Language).values({"name": "Korean"}).returning(Language.id))
    profile_id = db.scalar(
        insert(Profile).values({
            "name": name,
            "birth": date.today(),
            "sex": "",
            "major": "",
            "admission_year": 2023,
            "nation_code": 82,
        })
        .returning(Profile.id)
    )
    db.execute(insert(User).values({
        "salt": salt,
        "hash": hash,
        "user_id": profile_id,
        "verification_id": verification_id,
        "lang_id": lang_id,
    }))

    return profile_id


def teardown_user(db: DbSession):
    db.execute(delete(User))
    db.execute(delete(Profile))
    db.execute(delete(Language))
    db.execute(delete(Email))

