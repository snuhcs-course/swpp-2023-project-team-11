class UserAlreadyExistException(Exception):
    def __init__(self, email: str):
        self.email = email


class UserNotExistException(Exception):
    def __init__(self, email: str):
        self.email = email


class InvalidEmailException(Exception):
    def __init__(self, email: str):
        self.email = email


class InvalidEmailCodeException(Exception):
    def __init__(self, email: str):
        self.email = email


class InvalidEmailTokenException(Exception):
    def __init__(self, email: str):
        self.email = email
