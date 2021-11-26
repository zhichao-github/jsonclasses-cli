from jsonclasses.cdef import Cdef
from .interface import InterfaceItem, interface, interface_item
from .jtype_to_ts_type import jtype_to_ts_type


def session_input(cdef: Cdef) -> str:
    items: list[InterfaceItem] = []
    (identities, bys) = _session_input_items(cdef)
    use_session = hasattr(cdef.cls, 'auth_conf')
    identities_optional = len(identities) > 1
    bys_optional = len(bys) > 1
    for (n, t) in identities.items():
        items.append(interface_item(n, t, identities_optional))
    for (n, t) in bys.items():
        items.append(interface_item(n, t, bys_optional))
    name = cdef.name + 'SessionInput'
    return interface(name, items) if use_session else ''


def _session_input_items(cdef: Cdef) -> tuple[dict[str, str], dict[str, str]]:
    identities: dict[str, str] = {}
    bys: dict[str, str] = {}
    use_session = hasattr(cdef.cls, 'auth_conf')
    if use_session:
        for field in cdef.fields:
            fname = field.json_name
            ftype = jtype_to_ts_type(field.fdef, 'C')
            if field.fdef.auth_identity:
                identities[fname] = ftype
            elif field.fdef.auth_by:
                bys[field.json_name] = ftype
    return (identities, bys)
