from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from exceptions import *
import src.user.models
from src.database import *
import hmac, hashlib

#TODO: delete this line
HASH_SECRET = ""

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/sign_in")


def check_password(form: OAuth2PasswordRequestForm = Depends(),  db: Session = Depends(get_db)) -> str:
    user = db.query(src.user.models.User).filter(
        src.user.models.EmailVerification.email == form.username
    ).first()
    if user is None:
        raise UserNotExistException
    secret = bytes(HASH_SECRET, 'utf-8')
    message = bytes(form.password + user.salt, 'utf-8')
    signature = hmac.new(
        key=secret,
        msg=message,
        digestmod=hashlib.sha256
    ).digest()

    if signature != user.hash:
        raise PasswordMatchException
    return form.username
