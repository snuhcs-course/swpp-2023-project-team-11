from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting.constants import *
from src.chatting.intimacy.calculator import *
from src.chatting.intimacy.factory import *
from src.chatting.intimacy.service import *
from src.chatting.schemas import CreateChattingRequest
from src.database import DbConnector
from src.user.service import get_user_by_email


def check_counterpart(req: CreateChattingRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidUserException`"""

    return get_user_by_email(db, req.counterpart).user_id


# Global intimacy calculator (singleton)
__papago_factory = KoreanDetectionPapagoServiceFactory(PAPAGO_CLIENT_ID, PAPAGO_CLIENT_SECRET)
__clova_factory = ClovaServiceFactory(CLOVA_CLIENT_ID, CLOVA_CLIENT_SECRET)
__translation_fallback = lambda text: text
__translation = __papago_factory.create_service()
__translation = IgnoresEmptyTextService(__translation, __translation_fallback)
__translation = SuppressErrorTextService(__translation, __translation_fallback)
__sentiment_fallback = lambda _: 0
__sentiment = __clova_factory.create_service()
__sentiment = IgnoresEmptyTextService(__sentiment, __sentiment_fallback)
__sentiment = SuppressErrorTextService(__sentiment, __sentiment_fallback)

__calculator = IntimacyCalculator(__translation, __sentiment)


def get_intimacy_calculator() -> IntimacyCalculator:
    return __calculator
