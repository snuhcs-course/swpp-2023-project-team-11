from typing import List

from src.user.schemas import UserProfile


def create_verification_code(email: str) -> int:
    pass


def send_code_via_email(email: str, code: int):
    pass


def create_verification(email: str) -> str:
    pass


def create_user(email: str, password: str, user: UserProfile):
    pass


def get_user_recommendations(user: UserProfile) -> List[UserProfile]:
    pass
