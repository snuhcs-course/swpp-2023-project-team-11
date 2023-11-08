from fastapi import HTTPException


class ChattingNotExistException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='chatting does not exist')


class IntimacyNotExistException(HTTPException):
    def __init__(self):
        super().__init__(500, detail='intimacy does not exist')
