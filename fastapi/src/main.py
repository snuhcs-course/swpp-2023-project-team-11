from fastapi import FastAPI

from src.auth.router import router as auth_router
from src.user.router import router as user_router


app = FastAPI()
app.include_router(auth_router)
app.include_router(user_router)
