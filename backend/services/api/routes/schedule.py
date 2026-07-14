from websockets.version import tag
from fastapi import APIRouter

router = APIRouter(tags=["schedule"])


@router.get("/s/")
async def read_user_me():
    return {"message": "logging failed!"}

@router.post("/create/")
async def read_users():
    return {"user": "Rick", "message": "create Successfully"}

