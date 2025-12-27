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