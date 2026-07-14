from markdown_it.rules_block import table
from sqlmodel import SQLModel, Field
from typing import Optional


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=True, primary_key=True)
    name: str
    email: str
    password: str