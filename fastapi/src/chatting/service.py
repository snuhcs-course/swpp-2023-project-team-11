from typing import List, Tuple

from sqlalchemy import insert, update, desc, or_, func
from sqlalchemy.orm import Session as DbSession

from src.chatting.constants import DEFAULT_INTIMACY
from src.chatting.exceptions import *
from src.chatting.models import *


def get_chatting_by_id(db: DbSession, chatting_id: int) -> Chatting:
    """Raises `ChattingNotExistException`"""
    chatting = db.query(Chatting).where(Chatting.id == chatting_id).first()
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def get_all_chattings(db: DbSession, user_id: int, is_approved: bool, limit: int | None = None) -> List[Chatting]:
    query = db.query(Chatting).where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id)).where(
        Chatting.is_approved == is_approved).order_by(Chatting.is_terminated, desc(Chatting.created_at))
    if is_approved is False:
        query = query.where(Chatting.is_terminated == False)
    if limit is not None:
        limit = min(1, limit)
        query = query.limit(limit)

    return query.all()


def create_chatting(db: DbSession, user_id: int, responder_id: int) -> Chatting:
    # if there is non-terminated chatting, throw exception
    chatting = db.query(Chatting).where(or_((Chatting.initiator_id == user_id) & (Chatting.responder_id == responder_id), (Chatting.responder_id == user_id) & (Chatting.initiator_id == responder_id))).where(
        Chatting.is_terminated == False).first()
    if chatting is not None:
        raise ChattingAlreadyExistException()

    return db.scalar(
        insert(Chatting)
        .values(
            {
                "initiator_id": user_id,
                "responder_id": responder_id,
                "created_at": datetime.now(),
            }
        )
        .returning(Chatting)
    )


def approve_chatting(db: DbSession, user_id: int, chatting_id: int) -> Chatting:
    """Raises `ChattingNotExistException`"""

    chatting = db.scalar(
        update(Chatting)
        .values(is_approved=True)
        .where(Chatting.id == chatting_id)
        .where(Chatting.responder_id == user_id)
        .returning(Chatting)
    )
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def terminate_chatting(db: DbSession, user_id: int, chatting_id: int) -> Chatting:
    """Raises `ChattingNotExistException`"""

    chatting = db.scalar(
        update(Chatting)
        .values(is_terminated=True)
        .where(Chatting.id == chatting_id)
        .where(or_(Chatting.responder_id == user_id, Chatting.initiator_id == user_id))
        .returning(Chatting)
    )
    if chatting is None:
        raise ChattingNotExistException()

    return chatting


def get_all_texts(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
    seq_id: int = -1,
    limit: int | None = None,
    timestamp: datetime | None = None,
) -> List[Text]:
    query = (
        db.query(Text)
        .join(Text.chatting)
        .where(or_(Chatting.initiator_id == user_id, Chatting.responder_id == user_id))
        .where(Text.id > seq_id)
        .order_by(desc(Text.id))
    )
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if timestamp is not None:
        query = query.where(Text.timestamp <= timestamp)
    if limit is not None:
        query = query.limit(limit=limit)

    return query.all()


def get_all_intimacies(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
    limit: int | None = None,
    timestamp: datetime | None = None,
) -> List[Intimacy]:
    query = (
        db.query(Intimacy)
        .join(Intimacy.chatting)
        .where(Intimacy.user_id == user_id)
        .order_by(desc(Intimacy.id))
    )
    if chatting_id is not None:
        query = query.where(Chatting.id == chatting_id)
    if limit is not None:
        query = query.limit(limit=limit)
    if timestamp is not None:
        # timestamp보다 과거의 것을 불러오는 것
        query = query.where(Intimacy.timestamp <= timestamp)

    return query.all()


def get_intimacy(db: DbSession, user_id: int, chatting_id: int) -> Tuple[Intimacy, bool]:
    """Raises `IntimacyNotExistException`"""

    intimacies = get_all_intimacies(db, user_id, chatting_id, limit=2)
    if len(intimacies) == 0:
        raise IntimacyNotExistException()

    return intimacies[0], len(intimacies) == 1


def get_recent_intimacy(
    db: DbSession,
    user_id: int,
    chatting_id: int | None = None,
) -> Intimacy | None:
    intimacies = get_all_intimacies(db, user_id, chatting_id, limit=1)
    if len(intimacies) == 0:
        return None
    return intimacies[0]


def create_intimacy(db: DbSession, user_id: int | List[int], chatting_id: int, intimacy: float = DEFAULT_INTIMACY) -> List[Intimacy]:
    if isinstance(user_id, int):
        user_id = [user_id]

    timestamp = datetime.now()
    return list(db.scalars(insert(Intimacy).values([{
        "user_id": user_id,
        "chatting_id": chatting_id,
        "intimacy": intimacy,
        "timestamp": timestamp,
    } for user_id in user_id]).returning(Intimacy)))


def get_topics(db: DbSession, tag: str, limit: int, is_korean: bool = True) -> List[Topic]:
    topics = db.query(Topic).where(Topic.tag == tag).order_by(
        func.random()).limit(limit).all()

    return topics


def intimacy_tag(intimacy: Intimacy | None) -> str:
    if intimacy is None or intimacy.intimacy <= 40:
        return "C"
    elif intimacy.intimacy <= 70:
        return "B"
    else:
        return "A"
