from typing import cast
from jsonclasses.cdef import CDef
from jsonclasses_cli.utils.package_utils import to_client
from jsonclasses_server.aconf import AConf
from jsonclasses.cgraph import CGraph
from ...utils.join_lines import join_lines

def class_api(cgraph: CGraph) -> str:
    return join_lines([
        'class API {',
        *map(lambda c: _client_item(c), cgraph._map.values()),
        _sign_out(),
        '}'
    ], 2)


def _client_item(cdef: CDef) -> str:
    name  = cast(AConf, cdef.cls.aconf).name
    return join_lines([
        f"    get {name}(): {to_client(cdef)} {'{'}",
        f"        return new {to_client(cdef)}()",
        "    }"
    ])


def _sign_out() -> str:
    return join_lines([
        '    signOut(): void {',
        '       SessionManager.share.clearSession()',
        '    }'
    ])
