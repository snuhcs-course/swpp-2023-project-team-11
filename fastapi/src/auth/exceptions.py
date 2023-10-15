from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()


class PasswordMatchException(Exception):
    def __init__(self, name: str):
        self.name = name


@app.exception_handler(PasswordMatchException)
def password_match_exception_handler(req: Request, exc: PasswordMatchException):
    return JSONResponse(
        status_code=400,
        content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
    )


class UserAlreadyExistException(Exception):
    def __init__(self, name: str):
        self.name = name


@app.exception_handler(UserAlreadyExistException)
def password_match_exception_handler(req: Request, exc: PasswordMatchException):
    return JSONResponse(
        status_code=400,
        content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
    )


class UserNotExistException(Exception):
    def __init__(self, name: str):
        self.name = name


@app.exception_handler(UserNotExistException)
def password_match_exception_handler(req: Request, exc: PasswordMatchException):
    return JSONResponse(
        status_code=400,
        content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
    )