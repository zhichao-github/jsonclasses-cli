from inflection import camelize
from jsonclasses.cdef import Cdef
from jsonclasses.jfield import JField
from jsonclasses.fdef import (
    Fdef, ReadRule, WriteRule, Queryability, FType, FStore, Nullability
)
from jsonclasses.modifiers.required_modifier import RequiredModifier
from jsonclasses.modifiers.default_modifier import DefaultModifier
from .unary_sort_order import unary_sort_order
from .codable_struct import codable_struct, codable_struct_item
from .codable_enum import codable_enum, codable_enum_item
from .jtype_to_swift_type import jtype_to_swift_type
from ...utils.join_lines import join_lines


def data_class(cdef: Cdef) -> str:
    return join_lines([
        _class_create_input(cdef),
        _class_update_input(cdef),
        _class_sort_orders(cdef),
        _class_result_picks(cdef),
        _class_query(cdef),
        _class_result(cdef),
        _class_result(cdef, partial=True),
    ], 2)


def _class_create_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_create(field):
            continue
        optional = not _is_field_required_for_create(field)
        name = camelize(field.name, False)
        stype = jtype_to_swift_type(field.fdef, 'C')
        local_key = _is_field_local_key(field)
        if local_key:
            optional = True
        item = codable_struct_item('public', 'var', name, stype, optional)
        items.append(item)
        if local_key:
            idname = _field_ref_id_name(field)
            item = codable_struct_item('public', 'var', idname, 'String', True)
            items.append(item)
    return codable_struct(to_create_input(cdef), items)


def _class_update_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_update(field):
            continue
        name = camelize(field.name, False)
        stype = jtype_to_swift_type(field.fdef, 'U')
        local_key = _is_field_local_key(field)
        item = codable_struct_item('public', 'var', name, stype, True)
        items.append(item)
        if local_key:
            idname = _field_ref_id_name(field)
            item = codable_struct_item('public', 'var', idname, 'String', True)
            items.append(item)
    return codable_struct(to_update_input(cdef), items)


def _class_sort_orders(cdef: Cdef) -> str:
    fnames: list[str] = []
    for field in cdef.fields:
        if not _is_field_queryable(field):
            continue
        if is_field_primary(field):
            continue
        if is_field_ref(field):
            continue
        if not _field_can_read(field):
            continue
        fnames.append(camelize(field.name, False))
    enum_items: list[str] = []
    for name in fnames:
        enum_items.append(codable_enum_item(name, 'String', name))
        desc_name = name + 'Desc'
        enum_items.append(codable_enum_item(desc_name, 'String', "-" + name))
    name = to_sort_orders(cdef)
    enum = codable_enum(name, 'String', enum_items)
    unary = unary_sort_order(name, fnames, lambda s: s + 'Desc')
    return join_lines([enum, unary], 2)


def _class_result_picks(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_read(field):
            continue
        name = camelize(field.name, False)
        items.append(codable_enum_item(name, 'String', name))
    return codable_enum(to_result_picks(cdef), 'String', items)


def _class_query(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _is_field_queryable(field):
            continue
        name = camelize(field.name, False)
        type = jtype_to_swift_type(field.fdef, 'Q')
        if is_field_ref(field):
            if not _is_field_local_key(field):
                continue
            idname = _field_ref_id_name(field)
            item = codable_struct_item('public', 'var', idname, 'IDQuery', True, 'nil')
            items.append(item)
        else:
            item = codable_struct_item('public', 'var', name, type, True, 'nil')
            items.append(item)
    sort_orders = array(to_sort_orders(cdef))
    order = codable_struct_item(
        'fileprivate', 'var', '_order', sort_orders, True, 'nil')
    result_picks = array(to_result_picks(cdef))
    pick = codable_struct_item(
        'fileprivate', 'var', '_pick', result_picks, True, 'nil')
    omit = codable_struct_item(
        'fileprivate', 'var', '_omit', result_picks, True, 'nil')
    limit = codable_struct_item(
        'fileprivate', 'var', '_limit', 'Int', True, 'nil')
    skip = codable_struct_item(
        'fileprivate', 'var', '_skip', 'Int', True, 'nil')
    page_no = codable_struct_item(
        'fileprivate', 'var', '_pageNo', 'Int', True, 'nil')
    page_size = codable_struct_item(
        'fileprivate', 'var', '_pageSize', 'Int', True, 'nil')
    operators = [order, pick, omit, limit, skip, page_no, page_size]
    items.extend(operators)
    return codable_struct(to_query(cdef), items)


def _class_result(cdef: Cdef, partial: bool = False) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_read(field):
            continue
        optional = not _is_field_required_for_read(field)
        if partial:
            optional = True
        name = camelize(field.name, False)
        stype = jtype_to_swift_type(field.fdef, 'R')
        local_key = _is_field_local_key(field)
        item = codable_struct_item('public', 'let', name, stype, optional)
        items.append(item)
        if local_key:
            idname = _field_ref_id_name(field)
            item = codable_struct_item('public', 'let', idname, 'String', optional)
            items.append(item)
    name = to_result(cdef) if not partial else to_result_partial(cdef)
    return codable_struct(name, items)


def to_create_input(cdef: Cdef) -> str:
    return cdef.name + 'CreateInput'


def to_update_input(cdef: Cdef) -> str:
    return cdef.name + 'UpdateInput'


def to_sort_orders(cdef: Cdef) -> str:
    return cdef.name + 'SortOrder'


def to_result_picks(cdef: Cdef) -> str:
    return cdef.name + 'ResultPick'


def to_query(cdef: Cdef) -> str:
    return cdef.name + 'Query'


def to_result(cdef: Cdef) -> str:
    return cdef.name


def to_result_partial(cdef: Cdef) -> str:
    return 'Partial' + cdef.name


def _is_field_required_for_create(field: JField) -> bool:
    if _field_has_default(field):
        return False
    if _is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)


def _is_field_required_for_read(field: JField) -> bool:
    if _is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)


def _field_has_default(field: JField) -> bool:
    if _is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, DefaultModifier)), False)


def _is_field_nonnull(field: JField) -> bool:
    if field.fdef.ftype == FType.LIST:
        if field.fdef.fstore == FStore.LOCAL_KEY or field.fdef.fstore == FStore.FOREIGN_KEY:
            if field.fdef.collection_nullability == Nullability.NONNULL:
                return True
    return False


def _is_field_queryable(field: JField) -> bool:
    if field.fdef.read_rule == ReadRule.NO_READ:
        return False
    return field.fdef.queryability != Queryability.UNQUERYABLE


def _field_can_create(field: JField) -> bool:
    return field.fdef.write_rule != WriteRule.NO_WRITE


def _field_can_update(field: JField) -> bool:
    if field.fdef.write_rule == WriteRule.NO_WRITE:
        return False
    if field.fdef.write_rule == WriteRule.WRITE_ONCE:
        if _is_field_required_for_create(field):
            return False
    return True


def _field_can_read(field: JField) -> bool:
    if field.fdef.read_rule == ReadRule.NO_READ:
        return False
    if field.fdef.fstore == FStore.TEMP:
        return False
    return True


def _is_field_local_key(field: JField) -> bool:
    return field.fdef.fstore == FStore.LOCAL_KEY


def _field_ref_id_name(field: JField) -> str:
    return field.cdef.jconf.ref_key_encoding_strategy(field)


def is_field_primary(field: JField) -> bool:
    return field.fdef.primary


def is_field_ref(field: JField) -> bool:
    if field.fdef.fstore == FStore.LOCAL_KEY:
        return True
    if field.fdef.fstore == FStore.FOREIGN_KEY:
        return True
    return False


def array(val: str) -> str:
    return '[' + val + ']'
