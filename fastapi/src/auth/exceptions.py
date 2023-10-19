from fastapi import HTTPException


class InvalidUserException(HTTPException):
    def __init__(self):
        super().__init__(400, detail="user does not exist")


class InvalidPasswordException(HTTPException):
    def __init__(self):
        super().__init__(400, detail="wrong password")


class InvalidSessionException(HTTPException):
    def __init__(self):
        super().__init__(400, detail="session does not exist")
