from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting.constants import *
from src.chatting.schemas import CreateChattingRequest
from src.chatting import service
from src.database import DbConnector
from src.user.service import get_user_by_email


def check_counterpart(req: CreateChattingRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidUserException`"""

    return get_user_by_email(db, req.counterpart).user_id


# Global intimacy calculator (singleton)
# TODO move to intimacy
__papago_factory = service.KoreanDetetionPapagoServiceFactory(PAPAGO_CLIENT_ID, PAPAGO_CLIENT_SECRET)
__clova_factory = service.ClovaServiceFactory(CLOVA_CLIENT_ID, CLOVA_CLIENT_SECRET)
__translation = __papago_factory.create_service()
__sentiment = __clova_factory.create_service()

__calculator = service.IntimacyCalculator(__translation, __sentiment)


def get_intimacy_calculator() -> service.IntimacyCalculator:
    return __calculator
