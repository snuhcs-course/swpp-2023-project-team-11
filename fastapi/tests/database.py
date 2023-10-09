import unittest
from sqlalchemy import Integer, String, Column
from src.database import Base
from sqlalchemy.orm import relationship

class ForTest(Base):
    __tablename__ = "test_table"

    id = Column(Integer, primary_key=True)
    subject = Column(String, nullable=False)
