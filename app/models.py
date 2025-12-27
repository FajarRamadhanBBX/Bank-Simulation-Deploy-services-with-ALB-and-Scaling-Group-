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

class AccountRequest(BaseModel):
    account_number: str
    initial_balance: float

class AddBalanceRequest(BaseModel):
    account_number: str
    amount: float

class BalanceRequest(BaseModel):
    account_number: str

class TransferRequest(BaseModel):
    from_account: str
    to_account: str
    amount: float