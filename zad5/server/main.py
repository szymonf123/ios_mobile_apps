from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext

app = FastAPI()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# PROSTA "BAZA" (na start)
users_db = {}

class RegisterData(BaseModel):
    username: str
    password: str


class LoginData(BaseModel):
    username: str
    password: str


@app.post("/register")
def register(data: RegisterData):
    if data.username in users_db:
        raise HTTPException(status_code=400, detail="Użytkownik już istnieje")

    hashed_password = pwd_context.hash(data.password)

    users_db[data.username] = {
        "username": data.username,
        "hashed_password": hashed_password
    }

    return {"message": "Rejestracja zakończona sukcesem"}

@app.post("/login")
def login(data: LoginData):
    user = users_db.get(data.username)

    if not user:
        raise HTTPException(status_code=401, detail="Nieprawidłowy login")

    if not pwd_context.verify(data.password, user["hashed_password"]):
        raise HTTPException(status_code=401, detail="Nieprawidłowe hasło")

    return {"access_token": "FAKE_JWT_NA_RAZIE"}
