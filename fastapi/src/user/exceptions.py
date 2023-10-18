from fastapi import HTTPException


class InvalidEmailException(HTTPException):
    def __init__(self, email: str):
        super().__init__(400, detail=f'{email} is not a valid email')


class InvalidEmailCodeException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid email code')


class EmailInUseException(HTTPException):
    def __init__(self, email: str):
        super().__init__(400, detail=f'{email} is already in use')


class InvalidEmailTokenException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid email token')


class UserNotExistException(HTTPException):
    def __init__(self, email: str):
        self.email = email
