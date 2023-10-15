from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/sign_in")


def check_password(form: OAuth2PasswordRequestForm = Depends()) -> str:
    pass
    # if form.username != 'hello':
    #     raise HTTPException(status_code=401, detail="user does not exist")
    # return form.username
