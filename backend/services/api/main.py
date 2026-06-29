from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from services.api.auth_client import AuthGRPCClient

app = FastAPI(title="Meditake API Gateway")

auth_client = AuthGRPCClient()

class AuthRequest(BaseModel):
    username: str
    password: str

class TokenRequest(BaseModel):
    token: str

@app.get("/")
async def root():
    return {"message": "Welcome to MediTake API Gateway"}

@app.post("/api/auth/register")
async def register(request: AuthRequest):
    response = auth_client.register(request.username, request.password)
    if not response:
        raise HTTPException(status_code=500, detail="Auth service unavailable")
    if not response.success:
        raise HTTPException(status_code=400, detail=response.message)
    return {"message": response.message, "token": response.token}

@app.post("/api/auth/login")
async def login(request: AuthRequest):
    response = auth_client.login(request.username, request.password)
    if not response:
        raise HTTPException(status_code=500, detail="Auth service unavailable")
    if not response.success:
        raise HTTPException(status_code=401, detail=response.message)
    return {"message": response.message, "token": response.token}

@app.post("/api/auth/validate")
async def validate_token(request: TokenRequest):
    response = auth_client.validate_token(request.token)
    if not response:
        raise HTTPException(status_code=500, detail="Auth service unavailable")
    if not response.valid:
        raise HTTPException(status_code=401, detail="Invalid token")
    return {"valid": True, "username": response.username}