from typing import List
from sqlalchemy.orm import Session as DbSession

from src.chatting.models import *


def get_all_chattings(user_id: int, is_approved: bool, db: DbSession) -> List[Chatting]:
    # TODO
    pass


def create_chatting(user_id: int, responder_id: int, db: DbSession) -> Chatting:
    # TODO
    pass


def approve_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    # TODO
    pass


def terminate_chatting(user_id: int, chatting_id: int, db: DbSession) -> Chatting:
    # TODO
    pass


def get_all_texts(user_id: int, chatting_id: int | None, seq_id: int, limit: int | None, db: DbSession) -> List[Text]:
    # TODO
    pass
