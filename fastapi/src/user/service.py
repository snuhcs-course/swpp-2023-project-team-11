import numpy as np
import pandas as pd
from sqlalchemy.orm import Session as DbSession
from typing import List

from src.user.schemas import *
from src.user.models import *


def create_verification_code(email: str) -> int:
    pass


def send_code_via_email(email: str, code: int):
    pass


def create_verification(email: str) -> str:
    pass


def create_user(email: str, password: str, user: ProfileData):
    pass


def get_target_users(user: User, db: DbSession) -> List[User]:
    pass


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
