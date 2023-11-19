from typing import AsyncGenerator, Generator, Any
from sqlalchemy import Engine, create_engine
from sqlalchemy.ext.asyncio import AsyncEngine, create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.orm.decl_api import DeclarativeMeta
import os


# Base Model Class
Base: DeclarativeMeta = declarative_base()


class DbConnector:
    PG_DB = os.environ.get('SNEK_POSTGRES_DB')
    PG_USER = os.environ.get('SNEK_POSTGRES_USER')
    PG_PW = os.environ.get('SNEK_POSTGRES_PW')
    PG_HOST = os.environ.get('SNEK_POSTGRES_HOST')
    PG_URL: str = f"postgresql://{PG_USER}:{PG_PW}@{PG_HOST}:5432/{PG_DB}"
    PG_ASYNC_URL: str = f"postgresql+asyncpg://{PG_USER}:{PG_PW}@{PG_HOST}:5432/{PG_DB}"

    engine: Engine = create_engine(PG_URL)
    async_engine: AsyncEngine = create_async_engine(PG_ASYNC_URL)
    SessionLocal: sessionmaker[Session] = sessionmaker(
        autocommit=False, autoflush=False, bind=engine)
    AsyncSessionLocal: async_sessionmaker[AsyncSession] = async_sessionmaker(
        bind=async_engine, autoflush=False, autocommit=False)

    @classmethod
    def get_db(cls) -> Generator[Session, Any, None]:
        db = cls.SessionLocal()
        try:
            yield db
        finally:
            db.close()

    @classmethod
    async def get_async_db(cls) -> AsyncGenerator[AsyncSession, Any]:
        db = cls.AsyncSessionLocal()
        try:
            yield db
        finally:
            await db.close()
