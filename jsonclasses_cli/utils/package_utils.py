from jsonclasses.cdef import Cdef


def class_needs_api(cdef: Cdef) -> bool:
    return hasattr(cdef.cls, 'aconf')


def class_needs_session(cdef: Cdef) -> bool:
    return hasattr(cdef.cls, 'auth_conf')
