from typing import Any
from fastapi import HTTPException

from src.exceptions import ExternalApiError


class ChattingNotExistException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='chatting does not exist')


class IntimacyNotExistException(HTTPException):
    def __init__(self):
        super().__init__(500, detail='intimacy does not exist')


class ClovaApiException(ExternalApiError):
    def __init__(self) -> None:
        super().__init__(detail="sentimental")


class PapagoApiException(ExternalApiError):
    def __init__(self) -> None:
        super().__init__(detail="translation")

class ChattingAlreadyExistException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='chatting already exist')