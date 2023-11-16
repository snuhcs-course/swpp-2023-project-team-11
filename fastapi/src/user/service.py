import base64
from datetime import datetime
from email.message import EmailMessage
import hmac
import hashlib
import numpy as np
import pandas as pd
import random
from smtplib import SMTP_SSL
from sqlalchemy import insert, select, alias, update
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session as DbSession
from typing import List, Tuple

from src.constants import HASH_SECRET
from src.user.constants import *
from src.user.exceptions import *
from src.user.schemas import *
from src.user.models import *


def get_verification_code(db: DbSession, email: str) -> EmailCode:
    """Raises `InvalidEmailCodeException`"""

    code = db.scalar(select(EmailCode).join(
        EmailCode.email).where(Email.email == email))
    if code is None:
        raise InvalidEmailCodeException()

    return code


def create_verification_code(db: DbSession, email: str, code: int):
    obj = db.query(Email).where(Email.email == email).first()
    if obj is None:
        db.add(EmailCode(email=Email(email=email), code=code))
        db.flush()
    elif obj.code is None:
        db.execute(insert(EmailCode).values(
            {"email_id": obj.id, "code": code}))
    else:
        db.execute(update(EmailCode).values(
            code=code).where(EmailCode.email_id == obj.id))

    return code


def get_verification(db: DbSession, email: str) -> EmailVerification:
    """Raises `InvalidEmailTokenException`"""

    verification = db.scalar(select(EmailVerification).join(
        EmailVerification.email).filter(Email.email == email))
    if verification is None:
        raise InvalidEmailTokenException()

    return verification


def create_verification(db: DbSession, token: str, email: str, email_id: int):
    """Raises `EmailInUseException`"""

    verification = db.query(EmailVerification).where(
        EmailVerification.email_id == email_id).first()
    if verification is None:
        db.execute(insert(EmailVerification).values(
            {"token": token, "email_id": email_id}))
    elif verification.user is None:
        db.execute(update(EmailVerification).values(
            token=token).where(EmailVerification.email_id == email_id))
    else:
        raise EmailInUseException(email)


def get_user_by_id(db: DbSession, user_id: int) -> User:
    """Raises `InvalidUserException`"""

    user = db.query(User).where(User.user_id == user_id).first()
    if user is None:
        raise InvalidUserException()

    return user


def get_user_by_email(db: DbSession, email: str) -> User:
    """Raises `InvalidUserException`"""

    user = db.query(User).join(User.verification).join(
        EmailVerification.email).where(Email.email == email).first()
    if user is None:
        raise InvalidUserException()

    return user


def create_profile(db: DbSession, profile: ProfileData) -> int:
    """Raises `InvalidFoodException`, `InvalidMovieException`,
    `InvalidHobbyException`, `InvalidLocationException`"""

    profile_id = db.scalar(insert(Profile).values({
        "name": profile.name,
        "birth": profile.birth,
        "sex": profile.sex,
        "major": profile.major,
        "admission_year": profile.admission_year,
        "about_me": profile.about_me,
        "mbti": profile.mbti,
        "nation_code": profile.nation_code,
    }).returning(Profile.id))

    create_user_item(db, profile_id, user_food, "food_id", Food,
                     profile.foods, InvalidFoodException)
    create_user_item(db, profile_id, user_movie, "movie_id", Movie,
                     profile.movies, InvalidMovieException)
    create_user_item(db, profile_id, user_hobby, "hobby_id", Hobby,
                     profile.hobbies, InvalidHobbyException)
    create_user_item(db, profile_id, user_location, "location_id",
                     Location, profile.locations, InvalidLocationException)
    
    return profile_id


def get_language_by_name(db: DbSession, name: str) -> int:
    lang_id = db.scalar(select(Language.id).where(Language.name == name))
    if lang_id is None:
        raise InvalidLanguageException()
    return lang_id


def get_target_users(db, user: User) -> List[User]:
    filter = (Profile.nation_code != KOREA_CODE) if user.profile.nation_code == KOREA_CODE else (
        Profile.nation_code == KOREA_CODE)
    me = alias(user_lang, 'M')
    you = alias(user_lang, 'Y')
    return list(db.query(User).join(User.profile).where(filter).where(
        User.user_id.in_(
            select(you.c.user_id).join(me, you.c.lang_id == me.c.lang_id).where(me.c.user_id == user.user_id))))


def create_user(
    db: DbSession,
    req: CreateUserRequest,
    verification_id: int,
    profile_id: int,
    main_lang_id: int,
    salt: str,
    hash: str,
):
    """Raises `InvalidLanguageException`, `EmailInUseException`"""

    try:
        db.execute(insert(User).values({
            "user_id": profile_id,
            "verification_id": verification_id,
            "lang_id": main_lang_id,
            "salt": salt,
            "hash": hash,
        }))
    except IntegrityError:
        raise EmailInUseException(req.email)

    create_user_item(db, profile_id, user_lang, "lang_id", Language,
                     req.languages, InvalidLanguageException)


def create_user_item(db: DbSession, profile_id: int, table: Table, column: str, model: type[Base], items: List[str], exception: type[HTTPException]):
    """Raises `@exception`"""

    if len(items) == 0:
        return
    try:
        db.execute(insert(table).values([{
            "user_id": profile_id,
            column: select(model.id).where(model.name == item)
        }for item in items]))
    except IntegrityError:
        raise exception()


def sort_target_users(user: User, targets: List[User]) -> List[User]:
    if len(targets) == 0:
        return targets

    user_dict = {}
    for target in targets:
        user_dict[target.user_id] = target

    targets_sorted = []

    df_me = get_user_dataframe(user)
    df_targets = pd.DataFrame()
    for target in targets:
        df_target = get_user_dataframe(target)
        df_target["similarity"] = get_similarity(df_me, df_target)
        df_targets = pd.concat([df_targets, df_target])

    user_ids = df_targets.sort_values(
        by=["similarity"], ascending=False).loc[:, "id"]

    for user_id in user_ids:
        targets_sorted.append(user_dict[user_id])
    return targets_sorted


def get_user_dataframe(user: User) -> pd.DataFrame:
    my_dict = {
        "id": user.user_id,
        "foods": list(food for food in user.profile.foods),
        "movies": list(movie for movie in user.profile.movies),
        "hobbies": list(hobby for hobby in user.profile.hobbies),
        "locations": list(location for location in user.profile.locations)
    }
    return pd.DataFrame.from_dict(my_dict, orient="index").T


def get_similarity(df_me: pd.DataFrame, df_target: pd.DataFrame) -> float:
    cnt = 0
    my_size = 0
    target_size = 0
    features = ["foods", "movies", "hobbies", "locations"]

    for feature in features:
        my_list = np.array(df_me.loc[:, feature].to_list()).flatten()
        target_list = np.array(df_target.loc[:, feature].to_list()).flatten()
        cnt += len(set(my_list) & set(target_list))
        my_size += len(my_list)
        target_size += len(target_list)

    if my_size == 0 or target_size == 0:
        return None
    return cnt / np.sqrt((my_size * target_size))


def get_mbti_f(initiator: User, responder: User) -> int:
    initiator_mbti = initiator.profile.mbti
    responder_mbti = responder.profile.mbti
    num_F = 0
    if initiator_mbti is not None:
        num_F += initiator_mbti.count('f')
    if responder_mbti is not None:
        num_F += responder_mbti.count('f')
    return num_F


def generate_code() -> int:
    # 100000 ≤ code ≤ 999999
    return 100000 + max(0, min(int(random.random() * 900000), 900000))


def generate_token(email: str) -> str:
    payload = bytes(email + str(datetime.now()), 'utf-8')
    signature = hmac.new(HASH_SECRET, payload,
                         digestmod=hashlib.sha256).digest()
    return base64.urlsafe_b64encode(signature).decode('utf-8')


def generate_salt_hash(password: str) -> Tuple[str, str]:
    salt = base64.b64encode(random.randbytes(16)).decode()
    payload = bytes(password + salt, 'utf-8')
    signature = hmac.new(HASH_SECRET, payload,
                         digestmod=hashlib.sha256).digest()
    hash = base64.b64encode(signature).decode()

    return (salt, hash)


def send_code_via_email(email: str, code: int) -> None:
    msg = EmailMessage()
    msg["Subject"] = "SNEK verification code"
    msg["From"] = MAIL_ADDRESS
    msg["To"] = email
    msg.set_content(f"Please enter your code: {code}")

    with SMTP_SSL(MAIL_SERVER, MAIL_PORT) as smtp:
        smtp.login(MAIL_ADDRESS, MAIL_PASSWORD)
        smtp.send_message(msg)
