from fastapi import HTTPException


class InvalidChattingException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='chatting does not exist')
