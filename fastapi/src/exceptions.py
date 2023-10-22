from fastapi import HTTPException


class InternalServerError(HTTPException):
    def __init__(self) -> None:
        super().__init__(500, "internal server error")
