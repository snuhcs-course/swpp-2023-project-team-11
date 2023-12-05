from fastapi import HTTPException


class InvalidMessageException(HTTPException):
    def __init__(self, detail: str) -> None:
        super().__init__(status_code=400, detail=detail)


class InvalidMessageTypeException(InvalidMessageException):
    def __init__(self) -> None:
        super().__init__(detail="Invalid message type")
