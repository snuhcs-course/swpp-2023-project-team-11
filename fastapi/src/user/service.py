from email.message import EmailMessage
import numpy as np
import pandas as pd
import random
from smtplib import SMTP_SSL
from sqlalchemy import insert, select, alias
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


def create_user(email: str, password: str, user: ProfileData):
    pass


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
