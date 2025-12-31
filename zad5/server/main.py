from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta
import requests
import os
from google.oauth2 import id_token
from google.auth.transport import requests
import httpx

app = FastAPI()

SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 1

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")

GITHUB_CLIENT_ID = os.getenv("GITHUB_CLIENT_ID")
GITHUB_CLIENT_SECRET = os.getenv("GITHUB_CLIENT_SECRET")

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

class GitHubAuthData(BaseModel):
    code: str

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
def login_google(data: GoogleAuthData):
    try:
        idinfo = id_token.verify_oauth2_token(data.id_token, requests.Request(), GOOGLE_CLIENT_ID)
        userid = idinfo['sub']
        email = idinfo.get('email', 'Unknown')
        return {"message": "Zalogowano", "user_id": userid, "username": email}
    except ValueError:
        raise HTTPException(status_code=400, detail="Zły client_id")

class GitHubCode(BaseModel):
    code: str

@app.post("/auth/github")
async def github_login(data: GitHubCode):
    token_url = "https://github.com/login/oauth/access_token"
    headers = {"Accept": "application/json"}
    payload = {
        "client_id": GITHUB_CLIENT_ID,
        "client_secret": GITHUB_CLIENT_SECRET,
        "code": data.code,
        "redirect_uri": "myapp://oauth"
    }

    async with httpx.AsyncClient() as client:
        r = await client.post(token_url, headers=headers, data=payload)

    if r.status_code != 200:
        raise HTTPException(status_code=500, detail=f"GitHub token request failed: {r.text}")

    token_data = r.json()
    access_token = token_data.get("access_token")
    if not access_token:
        raise HTTPException(status_code=500, detail=f"No access token returned: {token_data}")

    # Pobranie danych użytkownika
    user_url = "https://api.github.com/user"
    async with httpx.AsyncClient() as client:
        r_user = await client.get(user_url, headers={"Authorization": f"token {access_token}"})

    user_data = r_user.json()
    username = user_data.get("login", "Unknown")

    return {"access_token": access_token, "username": username}