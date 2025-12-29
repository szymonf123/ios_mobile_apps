from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta
import requests
import os

app = FastAPI()

SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 1

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

users_db = {}

class RegisterData(BaseModel):
    username: str
    password: str

class LoginData(BaseModel):
    username: str
    password: str

class GoogleAuthData(BaseModel):
    id_token: str


def create_access_token(subject: str):
    payload = {
        "sub": subject,
        "exp": datetime.utcnow() + timedelta(hours=ACCESS_TOKEN_EXPIRE_HOURS)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

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

@app.post("/auth/google")
def auth_google(data: GoogleAuthData):
    response = requests.get(
        "https://oauth2.googleapis.com/tokeninfo",
        params={"id_token": data.id_token}
    )

    if response.status_code != 200:
        raise HTTPException(status_code=401, detail="Nieprawidłowy token Google")

    info = response.json()

    if info.get("aud") != GOOGLE_CLIENT_ID:
        raise HTTPException(status_code=401, detail="Zły client_id")

    email = info.get("email")

    if not email:
        raise HTTPException(status_code=400, detail="Brak emaila w tokenie")

    if email not in users_db:
        users_db[email] = {
            "username": email,
            "hashed_password": None,
            "auth_provider": "google"
        }

    token = create_access_token(email)

    return {
        "access_token": token,
        "username": email,
        "provider": "google"
    }
