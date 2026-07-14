from websockets.version import tag
from fastapi import APIRouter

router = APIRouter(tags=["prescription"])


@router.post("/create/")
async def create_prescription():
    return {"Search": "key?abcdefg"}