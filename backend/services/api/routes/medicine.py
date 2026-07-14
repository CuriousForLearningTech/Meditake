from websockets.version import tag
from fastapi import APIRouter

router = APIRouter(tags=["medicine"])


@router.post("/search/")
async def test_route():
    return {"Search": "key?abcdefg"}
