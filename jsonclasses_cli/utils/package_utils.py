from jsonclasses.cdef import Cdef


def class_needs_api(cdef: Cdef) -> bool:
    return hasattr(cdef.cls, 'aconf')


def class_needs_session(cdef: Cdef) -> bool:
    return hasattr(cdef.cls, 'auth_conf')


def to_create_input(cdef: Cdef) -> str:
    return cdef.name + 'CreateInput'


def to_update_input(cdef: Cdef) -> str:
    return cdef.name + 'UpdateInput'


def to_create_request(cdef: Cdef) -> str:
    return cdef.name + 'CreateRequest'


def to_update_request(cdef: Cdef) -> str:
    return cdef.name + 'UpdateRequest'


def to_delete_request(cdef: Cdef) -> str:
    return cdef.name + 'DeleteRequest'


def to_id_request(cdef: Cdef) -> str:
    return cdef.name + 'IDRequest'


def to_list_request(cdef: Cdef) -> str:
    return cdef.name + 'ListRequest'


def to_single_query(cdef: Cdef) -> str:
    return cdef.name + 'SingleQuery'


def to_list_query(cdef: Cdef) -> str:
    return cdef.name + 'ListQuery'


def to_result(cdef: Cdef) -> str:
    return cdef.name


def to_list_result(cdef: Cdef, mode: str = 'swift') -> str:
    return '[' + cdef.name + ']'


def to_result_picks(cdef: Cdef) -> str:
    return cdef.name + 'ResultPick'


def to_include(cdef: Cdef) -> str:
    return cdef.name + 'Include'


def to_sort_orders(cdef: Cdef) -> str:
    return cdef.name + 'SortOrder'
