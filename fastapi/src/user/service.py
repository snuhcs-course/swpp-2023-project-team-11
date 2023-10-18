import base64
from email.message import EmailMessage
import hmac, hashlib
import numpy as np
import pandas as pd
import random
from smtplib import SMTP_SSL
from sqlalchemy import insert, select, alias, update
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session as DbSession
from typing import List

from src.constants import HASH_SECRET
from src.user.constants import *
from src.user.exceptions import *
from src.user.schemas import *
from src.user.models import *


def create_verification_code(email: str, db: DbSession) -> int:
    # 100000 ≤ code ≤ 999999
    code = 100000 + max(0, min(int(random.random() * 900000), 900000))

    email_id = db.scalar(select(Email.id).where(Email.email == email))
    if email_id is None:
        email_id = db.scalar(insert(Email).values({"email": email}).returning(Email.id))

    if db.query(EmailCode).where(EmailCode.email_id == email_id).first() is None:
        db.execute(insert(EmailCode).values({"email_id": email_id, "code": code}))
    else:
        db.execute(update(EmailCode).values(code=code).where(EmailCode.email_id == email_id))
    db.flush()

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


def check_verification_code(req: VerificationRequest, db: DbSession) -> int:
    code = db.query(EmailCode).join(EmailCode.email).filter(Email.email == req.email).first()
    if code is None or code.code != req.code:
        raise InvalidEmailCodeException()

    return code.email_id


def create_verification(email: str, email_id: int, db: DbSession) -> str:
    payload = bytes(email, 'utf-8')
    signature = hmac.new(HASH_SECRET, payload, digestmod=hashlib.sha256).digest()
    token = base64.urlsafe_b64encode(signature).decode('utf-8')

    try:
        db.execute(insert(EmailVerification).values({"token": token, "email_id": email_id}))
    except IntegrityError:
        raise EmailInUseException(email)
    else:
        db.flush()

    return token


def check_verification_token(req: CreateUserRequest, db: DbSession) -> int:
    verification = db.query(EmailVerification).join(EmailVerification.email).filter(Email.email == req.email).first()
    if verification is None or verification.token != req.token:
        raise InvalidEmailTokenException()
    
    return verification.id


def create_user(req: CreateUserRequest, verification_id: int, db: DbSession) -> int:
    if req.main_language not in req.languages:
        req.languages.append(req.main_language)

    salt, hash = create_salt_hash(req.password)
    profile_id = db.scalar(insert(Profile).values({
            "name": req.profile.name,
            "birth": req.profile.birth,
            "sex": req.profile.sex,
            "major": req.profile.major,
            "admission_year": req.profile.admission_year,
            "about_me": req.profile.about_me,
            "mbti": req.profile.mbti,
            "nation_code": req.profile.nation_code,
        }).returning(Profile.id))
    db.execute(insert(User).values({
            "user_id": profile_id,
            "verification_id": verification_id,
            "lang_id": select(Language.id).where(Language.name == req.main_language).scalar_subquery(),
            "salt": salt,
            "hash": hash,
        }))
    db.flush()


def create_salt_hash(password: str) -> (str, str):
    salt = base64.b64encode(random.randbytes(16)).decode()
    payload = bytes(password + salt, 'utf-8')
    signature = hmac.new(HASH_SECRET, payload, digestmod=hashlib.sha256).digest()
    hash = base64.b64encode(signature).decode()
    return (salt, hash)


def get_target_users(user: User, db: DbSession) -> List[User]:
    filter = (Profile.nation_code != 82) if user.profile.nation_code == 82 else (Profile.nation_code == 82)
    me = alias(user_lang, 'M')
    you = alias(user_lang, 'Y')
    return list(db.query(User).join(User.profile).where(filter).where(
        User.user_id.in_(
            select(you.c.user_id).join(me, you.c.lang_id == me.c.lang_id).where(me.c.user_id == user.user_id))))


def sort_target_users(user: User, targets: List[User]) -> List[User]:
    user_dict = {}
    for target in targets:
        user_dict[target.user_id] = target

    targets_sorted = []

    df_me = get_user_dataframe(user)
    df_targets = pd.DataFrame()
    for target in targets:
        df_target = get_user_dataframe(target)
        df_target["count"] = count_intersection(df_me, df_target)
        df_targets = pd.concat([df_targets, df_target])

    user_ids = df_targets.sort_values(by=["count"], ascending=False).loc[:, "id"]

    for user_id in user_ids:
        targets_sorted.append(user_dict[user_id])
    return targets_sorted


def get_user_dataframe(user: User) -> pd.DataFrame:
    my_dict = {
        "id": user.user_id,
        "foods": list([food for food in user.profile.foods]),
        "movies": list([movie for movie in user.profile.movies]),
        "hobbies": list([hobby for hobby in user.profile.hobbies]),
        "locations": list([location for location in user.profile.locations])
    }
    return pd.DataFrame.from_dict(my_dict, orient="index").T


def count_intersection(df_me: pd.DataFrame, df_target: pd.DataFrame) -> int:
    cnt = 0
    features = ["foods", "movies", "hobbies", "locations"]

    for feature in features:
        my_list = np.array(df_me.loc[:, feature].to_list()).flatten()
        target_list = np.array(df_target.loc[:, feature].to_list()).flatten()
        cnt += len(set(my_list) & set(target_list))

    return cnt
