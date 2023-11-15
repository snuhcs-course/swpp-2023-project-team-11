from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import check_session
from src.auth.exceptions import InvalidSessionException
from src.chatting import service
from src.chatting.dependencies import *
from src.chatting.exceptions import *
from src.chatting.mapper import *
from src.chatting.schemas import *
from src.database import DbConnector
from src.exceptions import ErrorResponseDocsBuilder
from src.user.exceptions import InvalidUserException
from src.user.service import get_similarity, get_mbti_f, get_user_dataframe

router = APIRouter(prefix="/chatting", tags=["chatting"])


@router.get(
    "/",
    description="Get all chatting rooms",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .build()
)
def get_all_chattings(is_approved: bool, limit: int | None = None, user_id: int = Depends(check_session),
                      db: DbSession = Depends(DbConnector.get_db)) -> List[ChattingResponse]:
    return list(from_chatting(chatting) for chatting in service.get_all_chattings(db, user_id, is_approved, limit))


@router.post(
    "/",
    description="Initiate new chatting. The counterpart must approve later.",
    summary="Start chatting",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidUserException())
    .add(InvalidSessionException())
    .build()
)
def create_chatting(responder_id: int = Depends(check_counterpart), user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)) -> ChattingResponse:
    chatting = service.create_chatting(db, user_id, responder_id)
    db.commit()
    return from_chatting(chatting)


@router.put(
    "/",
    description="Approve chatting",
    summary="Approve chatting",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(ChattingNotExistException())
    .build()
)
def update_chatting(chatting_id: int, user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)) -> ChattingResponse:
    chatting = service.approve_chatting(db, user_id, chatting_id)
    service.create_intimacy(db, [user_id, chatting.initiator_id], chatting.id)
    db.commit()

    return from_chatting(chatting)


@router.delete(
    "/",
    description="Terminate chatting",
    summary="Terminate chatting",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(ChattingNotExistException())
    .build()
)
def delete_chatting(chatting_id: int, user_id: int = Depends(check_session),
                    db: DbSession = Depends(DbConnector.get_db)) -> ChattingResponse:
    chatting = service.terminate_chatting(db, user_id, chatting_id)
    db.commit()

    return from_chatting(chatting)


@router.get(
    "/text",
    description="",
    summary="",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .build()
)
def get_all_texts(seq_id: int = -1, limit: int | None = None, chatting_id: int | None = None, timestamp: datetime | None = None,
                  user_id: int = Depends(check_session), db: DbSession = Depends(DbConnector.get_db)) -> List[TextResponse]:
    return list(from_text(text) for text in service.get_all_texts(db, user_id, chatting_id, seq_id, limit, timestamp))


@router.post(
    "/intimacy",
    description="",
    summary="",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .add(ChattingNotExistException())
    .add(PapagoApiException())
    .add(ClovaApiException())
    .build()
)
def create_intimacy(chatting_id: int, user_id: int = Depends(check_session),
                    calculator: service.IntimacyCalculator = Depends(),
                    db: DbSession = Depends(DbConnector.get_db)) -> IntimacyResponse:
    recent_intimacy, is_default = service.get_intimacy(
        db, user_id, chatting_id)
    chatting = service.get_chatting_by_id(db, chatting_id)

    curr_texts = service.get_all_texts(db, user_id, chatting_id, limit=20)
    if is_default:
        prev_texts = service.get_all_texts(
            db, user_id, chatting_id, limit=20, timestamp=recent_intimacy.timestamp)
        initiator = chatting.initiator
        responder = chatting.responser
        df_initiator = get_user_dataframe(initiator)
        df_responder = get_user_dataframe(responder)
        similarity = get_similarity(df_initiator, df_responder)
        num_F = get_mbti_f(initiator, responder)
    else:
        # we cannot calculate delta value with default intimacy
        prev_texts = []
        similarity = None
        num_F = None

    intimacy = calculator.calculate(
        user_id, curr_texts, prev_texts, recent_intimacy, similarity, num_F)
    new_intimacy = service.create_intimacy(
        db, user_id, chatting_id, intimacy)[0]
    db.commit()

    return from_intimacy(new_intimacy)


@router.get(
    "/topic",
    description="",
    summary="",
    responses=ErrorResponseDocsBuilder()
    .add(InvalidSessionException())
    .build()
)
def get_topic_recommendation(chatting_id: int, limit: int = 1, user_id: int = Depends(check_session),
                             db: DbSession = Depends(DbConnector.get_db)) -> TopicResponse:
    intimacy = service.get_recent_intimacy(db, user_id, chatting_id)
    tag = service.intimacy_tag(intimacy)
    topics = service.get_topics(db, tag, limit)

    return list(from_topic(topic) for topic in topics)

# # TODO get intimacy endpoint 두 개 다 없애고 get chatting에 Intimacy 추가해서 보내기
# @router.get("/intimacy", response_model=IntimacyResponse)
# def get_intimacy(chatting_id: int, session: Session = Depends(get_session),
#                  db: DbSession = Depends(DbConnector.get_db)):
#     intimacy = service.get_recent_intimacy(user_id, chatting_id, db)
#     return from_intimacy(intimacy)

# @router.get("/intimacy/all", response_model=List[IntimacyResponse])
# def get_all_intimacy(chatting_id: int, session: Session = Depends(get_session),
#                  db: DbSession = Depends(DbConnector.get_db)):
#     intimacy = service.get_all_intimacies(user_id, chatting_id, None, None, db)
#     return list(from_intimacy(intimacy) for intimacy in intimacy)
