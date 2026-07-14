from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from contextlib import asynccontextmanager
from sqlmodel import SQLModel
from typing import Any

from services.api.routes.auth import router as auth_router
from services.api.routes.medicine import router as medicine_router
from services.api.routes.prescription import router as prescription_router
from services.api.routes.schedule import router as schedule_router
from services.api.db.engine import engine
from services.api.config import setting

app = FastAPI(
    title="Meditake API Gateway",
    version="v0.0.1",
    # root_path="api/v1",
    # docs_url="/docs"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=setting.allowed_origins,
    allow_methods='*',
    allow_headers='*',
)


app.include_router(auth_router)
app.include_router(prescription_router)
app.include_router(medicine_router)
app.include_router(schedule_router)

@app.get('/', tags=['status'])
def main() -> dict[str, Any]:
    return {'status': 'ok'}


