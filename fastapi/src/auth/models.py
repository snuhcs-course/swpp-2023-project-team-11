from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import Mapped

from src.database import Base


class Session(Base):
    __tablename__ = "session"

    id: Mapped[int] = Column(Integer, primary_key=True, autoincrement=True)
    session_key: Mapped[str] = Column(String(44), nullable=False, unique=True)
    user_id: Mapped[int] = Column(ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False)
