from __future__ import annotations
from jsonclasses import jsonclass, types
from jsonclasses_server import api, authorized




@authorized
@api
@jsonclass(class_graph='user')
class User:
    id: str = types.readonly.str.primary.mongoid.required
    username: str = types.str.authidentity.writenonnull.required
    password: str = types.str.writeonly.writenonnull.salt.authbycheckpw.unqueryable.required
    phone_num: str | None = types.str.alnum


@api
@jsonclass(class_graph='user')
class Article:
    id: str = types.readonly.str.primary.mongoid.required
    title: str = types.str.required
    content: str = types.str
