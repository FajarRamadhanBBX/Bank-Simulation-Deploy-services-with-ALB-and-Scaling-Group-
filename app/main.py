from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy.exc import OperationalError
from sqlalchemy import text

from database import SessionLocal, engine
from models import Base, Account, Transaction
from schemas import (AccountRequest, BalanceRequest, AddBalanceRequest, TransferRequest)

import time

app = FastAPI(title="Banking API with RDS")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def check_database_connection():
    try:
        db = SessionLocal()
        db.execute(text("SELECT 1"))
        return True
    except Exception:
        return False
    finally:
        db.close()

@app.get("/ping")
def ping():
    return {"status": "ok"}

@app.get("/health")
def health_check():
    if check_database_connection():
        return {"status": "ready", "db": "connected"}
    else:
        raise HTTPException(status_code=503, detail="DB not ready")

@app.post("/account")
def create_account(data: AccountRequest, db: Session = Depends(get_db)):
    account = Account(account_number=data.account_number, balance=data.initial_balance)
    db.add(account)
    db.commit()
    db.refresh(account)
    return account

@app.post("/balance")
def get_balance(data: BalanceRequest, db: Session = Depends(get_db)):
    account = db.query(Account).filter_by(account_number=data.account_number).first()
    if not account:
        return {"error": "Account not found"}
    return {"account": account.account_number, "balance": account.balance}

@app.post("/add_balance")
def add_funds(data: AddBalanceRequest, db: Session = Depends(get_db)):
    account = db.query(Account).filter_by(account_number=data.account_number).first()
    if not account:
        return {"error": "Account not found"}
    account.balance += data.amount
    db.commit()
    return {"account": account.account_number, "new_balance": account.balance}

@app.post("/transfer")
def transfer(data: TransferRequest, db: Session = Depends(get_db)):
    from_acc = db.query(Account).filter_by(account_number=data.from_account).first()
    to_acc = db.query(Account).filter_by(account_number=data.to_account).first()
    if not from_acc or not to_acc:
        return {"error": "Invalid account"}
    if from_acc.balance < data.amount:
        return {"error": "Insufficient balance"}
    time.sleep(0.2)
    from_acc.balance -= data.amount
    to_acc.balance += data.amount
    tx = Transaction(
        from_account=data.from_account,
        to_account=data.to_account,
        amount=data.amount
    )
    db.add(tx)
    db.commit()
    return {
        "status": "SUCCESS",
        "amount": data.amount
    }

@app.get("/get_all_data")
def get_all_data(db: Session = Depends(get_db)):
    accounts = db.query(Account).all()
    transactions = db.query(Transaction).all()
    return {
        "accounts": accounts,
        "transactions": transactions
    }

@app.get("/get_all_accounts")
def get_all_accounts(db: Session = Depends(get_db)):
    accounts = db.query(Account).all()
    return {"accounts": accounts}

@app.get("/get_all_transactions")
def get_all_transactions(db: Session = Depends(get_db)):
    transactions = db.query(Transaction).all()
    return {"transactions": transactions}