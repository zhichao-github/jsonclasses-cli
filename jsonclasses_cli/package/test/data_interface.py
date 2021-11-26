from inflection import camelize
from jsonclasses.cdef import Cdef
from .interface import interface, interface_first_line, interface_include_key_item, interface_item, interface_type_item
from .jtype_to_ts_type import jtype_to_ts_type
from .shared_utils import (
    field_ref_id_name, is_field_local_key, is_field_primary, is_field_ref, is_field_required_for_read,
    field_can_read, field_can_create, is_field_required_for_create,
    field_can_update, is_list_field, is_field_required_null_for_update, string,
    is_field_queryable, to_include_name)
from ...utils.package_utils import to_create_input, to_include, to_list_query, to_result, to_result_picks, to_sort_orders, to_update_input
from ...utils.join_lines import join_lines


def data_interface(cdef: Cdef) -> str:
    return join_lines([
        _interface_result(cdef),
        _interface_create_input(cdef),
        _interface_update_input(cdef),
        _interface_sort_order(cdef),
        _interface_result_pick(cdef),
        _interface_include_keys(cdef),
        _interface_include_type(cdef),
    ], 2)


def _interface_result(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not field_can_read(field):
            continue
        name = field.json_name
        ftype = jtype_to_ts_type(field.fdef, 'R')
        optional = not is_field_required_for_read(field)
        item = interface_item(name, ftype, optional)
        items.append(item)
        local_key = is_field_local_key(field)
        if local_key:
            is_list = '[]' if is_list_field(field) else ''
            idname = field_ref_id_name(field)
            idtype = jtype_to_ts_type(cdef.primary_field.fdef, 'R') + is_list
            item = interface_item(idname, idtype, optional)
            items.append(item)
    name = to_result(cdef)
    return interface(name, items)


def _interface_create_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not field_can_create(field):
            continue
        optional = not is_field_required_for_create(field)
        name = field.json_name
        ftype = jtype_to_ts_type(field.fdef, 'C')
        optional = not is_field_required_for_read(field)
        item = interface_item(name, ftype, optional)
        items.append(item)
        local_key = is_field_local_key(field)
        if local_key:
            is_list = '[]' if is_list_field(field) else ''
            idname = field_ref_id_name(field)
            idtype = jtype_to_ts_type(cdef.primary_field.fdef, 'C') + is_list
            item = interface_item(idname, idtype, optional)
            items.append(item)
    name = to_create_input(cdef)
    return interface(name, items)


def _interface_update_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not field_can_update(field):
            continue
        null_for_update = '' if is_field_required_null_for_update(field) else ' | null'
        name = field.json_name
        ftype = jtype_to_ts_type(field.fdef, 'U') + null_for_update
        item = interface_item(name, ftype, True)
        items.append(item)
        local_key = is_field_local_key(field)
        if local_key:
            is_list = '[]' if is_list_field(field) else ''
            idname = field_ref_id_name(field)
            idtype = jtype_to_ts_type(cdef.primary_field.fdef, 'U') + is_list + null_for_update
            item = interface_item(idname, idtype, True)
            items.append(item)
    name = to_update_input(cdef)
    return interface(name, items)


def _interface_sort_order(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not is_field_queryable(field):
            continue
        if is_field_primary(field):
            continue
        if is_field_ref(field):
            continue
        if not field_can_read(field):
            continue
        name = camelize(field.name, False)
        items.append(string(name))
        items.append(string('-' + name))
    name = to_sort_orders(cdef)
    return interface_type_item(name, items)


def _interface_result_pick(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not field_can_read(field):
            continue
        name = string(camelize(field.name, False))
        items.append(name)
        if is_field_local_key(field):
            idname = string(field_ref_id_name(field))
            items.append(idname)
    name = to_result_picks(cdef)
    return interface_type_item(name, items)


def _interface_include_keys(cdef: Cdef) -> str:
    cname = cdef.name
    keys: list[str] = []
    for field in cdef.fields:
        if is_field_ref(field):
            name = to_include_name(cname, field.name)
            keys.append(_interface_include_key(name, field.name))
    return join_lines(keys, 2)


def _interface_include_key(name: str, key: str) -> str:
    include_type = camelize(key + 'ListQuery')
    return join_lines([
        interface_first_line(name),
        interface_include_key_item(key, include_type),
        '}'
    ])


def _interface_include_type(cdef: Cdef) -> str:
    cname = cdef.name
    include_types: list[str] = []
    for field in cdef.fields:
        if is_field_ref(field):
            name = to_include_name(cname, field.name)
            include_types.append(name)
    return interface_type_item(to_include(cdef), include_types)

# def _interface_single_query(cdef: Cdef) -> str:
#     items: list[str] = []
#     for field in cdef.fields:

#     name = to_single_query(cdef)