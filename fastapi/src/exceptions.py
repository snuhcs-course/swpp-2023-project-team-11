from typing import Any, Dict, Self

from fastapi import HTTPException
from pydantic import BaseModel


class ErrorResponseDocsBuilder:
    """Builder pattern for constructing responses for openapi docs"""

    class __Response(BaseModel):
        detail: str

    __responses: Dict[int | str, Dict[str, Any]]

    def __init__(self):
        self.__responses = {}

    @classmethod
    def __response(cls, description: str) -> Dict[str, Any]:
        return {
            "description": description,
            "model": cls.__Response,
        }

    def add(self, error: HTTPException) -> Self:
        status = error.status_code
        if self.__responses.get(status) is None:
            self.__responses[status] = self.__response(error.detail)
        else:
            self.__responses[status]["description"] += " / " + error.detail
        return self

    def build(self) -> Dict[int | str, Dict[str, Any]]:
        return self.__responses


class InternalServerError(HTTPException):
    def __init__(self) -> None:
        super().__init__(500, "internal server error")


class ExternalApiError(HTTPException):
    def __init__(self, detail: Any = None) -> None:
        super().__init__(502, detail)
