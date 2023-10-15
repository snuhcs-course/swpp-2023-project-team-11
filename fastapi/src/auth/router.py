from fastapi import APIRouter, Depends

from src.auth.dependencies import oauth2_scheme, check_password
from src.auth.schemas import SessionResponse
from src.auth import service


router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/sign_in", response_model=SessionResponse)
def create_session(email: str = Depends(check_password)):
    session_key = service.create_session(email)
    return SessionResponse(access_token=session_key, token_type="bearer")


@router.post("/sign_out", response_model=None)
def delete_session(session_key: str = Depends(oauth2_scheme)):
    service.delete_session(session_key)
