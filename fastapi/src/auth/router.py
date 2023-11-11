from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session as DbSession

from src.auth.dependencies import oauth2_scheme, check_password
from src.auth.schemas import SessionResponse
from src.auth import service
from src.database import DbConnector


router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/sign_in", response_model=SessionResponse)
def create_session(user_id: int = Depends(check_password), db: DbSession = Depends(DbConnector.get_db)):
    session_key = service.create_session(user_id, db)
    db.commit()
    return SessionResponse(access_token=session_key, token_type="bearer")


@router.delete("/sign_out", response_model=None)
def delete_session(session_key: str = Depends(oauth2_scheme), db: DbSession = Depends(DbConnector.get_db)):
    service.delete_session(session_key, db)
    db.commit()
