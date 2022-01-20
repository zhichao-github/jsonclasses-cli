from __future__ import annotations
from datetime import datetime
from typing import Annotated
from jsonclasses import jsonclass, types, linkedthru
from jsonclasses_server import api



@api
@jsonclass(class_graph='linkedthru')
class User:
    id: str = types.readonly.str.primary.mongoid.required
    phone_num: str | None = types.str.alnum
    articles: Annotated[list[Article], linkedthru('users')]

@api
@jsonclass(class_graph='linkedthru')
class Article:
    id: str = types.readonly.str.primary.mongoid.required
    title: str = types.str.required
    content: str = types.str
    users: Annotated[list[User], linkedthru('articles')]

