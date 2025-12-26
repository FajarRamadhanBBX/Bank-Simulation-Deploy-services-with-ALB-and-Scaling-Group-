from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session
import time

from database import SessionLocal, engine
from models import Base, Account, Transaction

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Banking API with RDS")

class TransferRequest(BaseModel):
    from_account: str
    to_account: str
    amount: float

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/ping")
def ping():
    return {"status": "ok", "code": 200}

@app.get("/health")
def health_check():
    # Cek koneksi
    db_status = check_database_connection() 
    
    if db_status:
        return {"status": "ready", "db": "connected"}
    else:
        # Return 503 agar Load Balancer tahu server ini jangan diberikan trafik dulu
        raise HTTPException(status_code=503, detail="Database connection failed")

@app.get("/balance")
def get_balance(account_number: str, db: Session = Depends(get_db)):
    account = db.query(Account).filter_by(account_number=account_number).first()
    if not account:
        return {"error": "Account not found"}

    return {
        "account": account.account_number,
        "balance": account.balance
    }

@app.post("/transfer")
def transfer(data: TransferRequest, db: Session = Depends(get_db)):
    from_acc = db.query(Account).filter_by(account_number=data.from_account).first()
    to_acc = db.query(Account).filter_by(account_number=data.to_account).first()

    if not from_acc or not to_acc:
        return {"error": "Invalid account"}

    if from_acc.balance < data.amount:
        return {"error": "Insufficient balance"}

    # Simulasi proses bank (latency)
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
