from fastapi import APIRouter

router = APIRouter(tags=["auth"],prefix="/auth")


@router.post("/register")
async def read_users():
    return {"user": "Rick", "message": "create Successfully"}


@router.post("/login")
async def read_user_me():
    return {"message": "logging failed!"}


@router.post("/refershToken/{id}")
async def read_user(username: str):
    return {"username": username}
