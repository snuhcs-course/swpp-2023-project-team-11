from typing import Any
from fastapi import HTTPException


class InternalServerError(HTTPException):
    def __init__(self) -> None:
        super().__init__(500, "internal server error")


class ExternalApiError(HTTPException):
    def __init__(self, detail: Any = None) -> None:
        super().__init__(502, detail)
