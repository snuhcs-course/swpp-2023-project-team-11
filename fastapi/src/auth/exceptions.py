from fastapi import HTTPException


class InvalidPasswordException(HTTPException):
    def __init__(self):
        super().__init__(400, detail="wrong password")


class InvalidSessionException(HTTPException):
    def __init__(self):
        super().__init__(401, detail="session does not exist")
