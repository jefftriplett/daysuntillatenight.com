import pandas
import sqlite_utils
import time
import typer

from pandas import DataFrame
from pathlib import Path
from pydantic import BaseModel
from pydantic import Field
from pydantic import validator
from pydantic.error_wrappers import ValidationError
from rich.console import Console
from rich.table import Table
from slugify import slugify
from typing import Optional


class Page(BaseModel):
    current_year: int
    layout: Optional[str] = "latenights"
    permalink: Optional[str] = None
    season: Optional[str] = None
    when: Optional[str] = "TBD"

    # def __init__(self, **data):
    #     super().__init__(**data)
    #     self.season = f"{self.current_year}-{self.current_year+1}"


class Player(BaseModel):
    class_: Optional[str] = Field(None, alias="class")
    departing_reason: Optional[str] = None
    first_name: str
    height: Optional[str] = None
    high_school: Optional[str] = None
    hometown: Optional[str] = None
    image: Optional[str] = "/images/blank.gif"
    last_name: str
    notes: Optional[str] = None
    number: Optional[int] = None
    position: Optional[str] = None
    projected: Optional[str] = None
    redshirt: Optional[bool] = None
    slug: Optional[str] = None
    status: Optional[str] = "active"
    weight: Optional[str] = None
    # year: str
    year: int

    def __init__(self, **data):
        super().__init__(**data)
        self.slug = slugify(
            " ".join(
                [
                    f"{self.year}",
                    f"{self.last_name}",
                    f"{self.first_name}",
                ]
            )
        )

    @validator("height", pre=True)
    def height_normalized(cls, v: Optional[str]) -> Optional[str]:
        if "''" in v:
            return v.replace("''", '"')
        return v

    @validator("number", pre=True)
    def number_is_never_empty(cls, v: Optional[str]) -> Optional[int]:
        if v == "":
            return None
        if isinstance(v, str) and not v.isdigit():
            return None
        return v


class Year(BaseModel):
    current_year: int
    season: str
    when: Optional[str] = None
