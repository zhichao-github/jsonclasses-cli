from __future__ import annotations
from datetime import datetime
from jsonclasses import jsonclass, types
from jsonclasses_server import api

@api
@jsonclass(class_graph='simple_song')
class SimpleSong:
    id: str = types.readonly.str.primary.mongoid.required
    name: str
    created_at: datetime = types.readonly.datetime.tscreated.required
    updated_at: datetime = types.readonly.datetime.tsupdated.required
