from fastapi import Depends
from sqlalchemy.orm import Session as DbSession

from src.chatting.schemas import CreateChattingRequest
from src.chatting import service
from src.database import DbConnector
from src.user.service import get_user_by_email


def check_counterpart(req: CreateChattingRequest, db: DbSession = Depends(DbConnector.get_db)) -> int:
    """Raises `InvalidUserException`"""

    return get_user_by_email(db, req.counterpart).user_id


# Global intimacy calculator
__translation = service.IgnoresEmptyInputTranslationClient(service.PapagoClient)
__sentiment = service.IgnoresEmptyInputSentimentClient(service.ClovaClient)
__calculator = service.IntimacyCalculator(__translation, __sentiment)


def get_intimacy_calculator() -> service.IntimacyCalculator:
    return __calculator
