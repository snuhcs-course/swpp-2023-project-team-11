from fastapi import FastAPI

from src.auth.router import router as auth_router
from src.chatting.router import router as chatting_router
from src.user.router import router as user_router
from src.websocket.router import router as websocket_router


app = FastAPI()
app.include_router(auth_router)
app.include_router(user_router)
app.include_router(chatting_router)
app.include_router(websocket_router)
