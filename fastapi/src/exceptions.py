from typing import Any, Dict

from fastapi import HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel


class ErrorResponseDocsBuilder:
    """Builder pattern for constructing responses for openapi docs"""

    class __Response(BaseModel):
        detail: str

    __responses: Dict[int | str, Dict[str, Any]]

    def __init__(self):
        self.__responses = {}
        self.add(CustomResponseValidationError())

    @classmethod
    def __response(cls, description: str) -> Dict[str, Any]:
        return {
            "description": description,
            "model": cls.__Response,
        }

    def add(self, error: HTTPException):
        status = error.status_code
        if self.__responses.get(status) is None:
            self.__responses[status] = self.__response(error.detail)
        else:
            self.__responses[status]["description"] += " / " + error.detail
        return self

    def build(self) -> Dict[int | str, Dict[str, Any]]:
        return self.__responses


class CustomResponseValidationError(HTTPException):
    def __init__(self, detail: Any = "failed to parse or validate request") -> None:
        super().__init__(422, detail)


class InternalServerError(HTTPException):
    def __init__(self) -> None:
        super().__init__(500, "internal server error")


class ExternalApiError(HTTPException):
    def __init__(self, detail: Any = None) -> None:
        super().__init__(502, detail)


async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors()[0]["msg"]},
    )
