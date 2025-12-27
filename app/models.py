from sqlalchemy import Column, Integer, String, Float, DateTime
from sqlalchemy.orm import declarative_base
from datetime import datetime

Base = declarative_base()

class Account(Base):
    __tablename__ = "accounts"

    id = Column(Integer, primary_key=True)
    account_number = Column(String, unique=True, index=True)
    balance = Column(Float, default=0.0)

class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True)
    from_account = Column(String)
    to_account = Column(String)
    amount = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)