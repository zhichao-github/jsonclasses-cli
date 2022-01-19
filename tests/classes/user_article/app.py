from __future__ import annotations
from typing import Annotated
from jsonclasses import jsonclass, types, linkto
from jsonclasses.typing import linkedby, linkedthru
from jsonclasses_server import api, authorized, server




@authorized
@api
@jsonclass
class User:
    id: str = types.readonly.str.primary.mongoid.required
    username: str = types.str.authidentity.required
    password: str = types.str.authbycheckpw.unqueryable.required
    phone_num: str | None = types.str.alnum
    articles: list[Article] = types.nonnull.listof('Article').linkedby('author')



@api
@jsonclass
class Article:
    id: str = types.readonly.str.primary.mongoid.required
    title: str = types.str.required
    content: str = types.str
    author: list[User] = types.nonnull.linkto.listof('User')







