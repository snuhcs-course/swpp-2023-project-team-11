from fastapi import HTTPException


class InvalidEmailException(HTTPException):
    def __init__(self, email: str = "given email"):
        super().__init__(400, detail=f'{email} is not a valid email')


class InvalidEmailCodeException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid email code')


class EmailInUseException(HTTPException):
    def __init__(self, email: str = "given email"):
        super().__init__(400, detail=f'{email} is already in use')


class InvalidEmailTokenException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid email token')


class InvalidFoodException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid food(s)')


class InvalidMovieException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid movie(s)')


class InvalidHobbyException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid hobby(s)')


class InvalidLocationException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid location(s)')


class InvalidLanguageException(HTTPException):
    def __init__(self):
        super().__init__(400, detail='invalid language(s)')


class InvalidUserException(HTTPException):
    def __init__(self):
        super().__init__(400, detail="user does not exist")
