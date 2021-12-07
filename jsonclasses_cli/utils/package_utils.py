from jsonclasses.cdef import CDef
from jsonclasses.cgraph import CGraph


def class_needs_api(cdef: CDef) -> bool:
    return hasattr(cdef.cls, 'aconf')


def session_input_cdefs(cgraph: CGraph) -> list[CDef]:
    items: list[CDef]  = []
    for cdef in cgraph._map.values():
        if class_needs_session(cdef):
            items.append(cdef)
    return items


def class_needs_session(cdef: CDef) -> bool:
    return hasattr(cdef.cls, 'auth_conf')


def to_create_input(cdef: CDef) -> str:
    return cdef.name + 'CreateInput'


def to_update_input(cdef: CDef) -> str:
    return cdef.name + 'UpdateInput'


def to_create_request(cdef: CDef) -> str:
    return cdef.name + 'CreateRequest'


def to_update_request(cdef: CDef) -> str:
    return cdef.name + 'UpdateRequest'


def to_delete_request(cdef: CDef) -> str:
    return cdef.name + 'DeleteRequest'


def to_id_request(cdef: CDef) -> str:
    return cdef.name + 'IDRequest'


def to_list_request(cdef: CDef) -> str:
    return cdef.name + 'ListRequest'


def to_single_query(cdef: CDef) -> str:
    return cdef.name + 'SingleQuery'


def to_list_query(cdef: CDef) -> str:
    return cdef.name + 'ListQuery'


def to_result(cdef: CDef) -> str:
    return cdef.name


def to_list_result(cdef: CDef, mode: str = 'swift') -> str:
    return '[' + cdef.name + ']'


def to_result_picks(cdef: CDef) -> str:
    return cdef.name + 'ResultPick'


def to_include(cdef: CDef) -> str:
    return cdef.name + 'Include'


def to_sort_orders(cdef: CDef) -> str:
    return cdef.name + 'SortOrder'


def to_session_input(cdef: CDef) -> str:
    return cdef.name + 'SessionInput'
