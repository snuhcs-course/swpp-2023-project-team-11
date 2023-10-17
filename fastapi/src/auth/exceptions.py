class InvalidUserException(Exception):
    def __init__(self, email: str):
        self.email = email


class InvalidPasswordException(Exception):
    pass


class InvalidSessionException(Exception):
    pass


# @app.exception_handler(PasswordMatchException)
# def password_match_exception_handler(req: Request, exc: PasswordMatchException):
#     return JSONResponse(
#         status_code=400,
#         content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
#     )


# @app.exception_handler(UserAlreadyExistException)
# def password_match_exception_handler(req: Request, exc: PasswordMatchException):
#     return JSONResponse(
#         status_code=400,
#         content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
#     )


# @app.exception_handler(UserNotExistException)
# def password_match_exception_handler(req: Request, exc: PasswordMatchException):
#     return JSONResponse(
#         status_code=400,
#         content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."},
#     )