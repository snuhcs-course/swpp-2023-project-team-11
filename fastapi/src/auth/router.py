from typing import Annotated

from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm

from src.auth.dependencies import oauth2_scheme


router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/sign_in")
def create_session(form: OAuth2PasswordRequestForm = Depends()):
    pass
    # if service.check_password(req.email, req.password):
    #     session_id = service.create_session(req.email)
    #     # TODO add session id into the header


@router.post("/sign_out")
def delete_session(session_id: str = Depends(oauth2_scheme)):
    pass
    # # TODO get session id from the header
    # session_id = None
    # service.delete_session(session_id)
