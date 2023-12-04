from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError

from src.auth.router import router as auth_router
from src.database import DbConnector
from src.exceptions import validation_exception_handler
from src.chatting.router import router as chatting_router
from src.user.router import router as user_router
from src.websocket.router import router as websocket_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    # Clean up the Async DB Resource
    await DbConnector.async_engine.dispose()


app = FastAPI(lifespan=lifespan)
app.include_router(auth_router)
app.include_router(chatting_router)
app.include_router(user_router)
app.include_router(websocket_router)
app.exception_handler(RequestValidationError)(validation_exception_handler)
