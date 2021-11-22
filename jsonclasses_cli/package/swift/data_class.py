from inflection import camelize
from jsonclasses.cdef import Cdef
from jsonclasses.jfield import JField
from jsonclasses.fdef import (
    Fdef, ReadRule, WriteRule, Queryability, FType, FStore, Nullability
)
from jsonclasses.modifiers.required_modifier import RequiredModifier
from jsonclasses.modifiers.default_modifier import DefaultModifier
from jsonclasses_cli.utils.join_lines import join_lines
from .codable_struct import codable_struct, codable_struct_item
from .jtype_to_swift_type import jtype_to_swift_type


def data_class(cdef: Cdef) -> str:
    return join_lines([
        _class_create_input(cdef),
        _class_update_input(cdef),
        _class_query(cdef),
    ], 2)


def _class_create_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_create(field):
            continue
        optional = not _is_field_required_for_create(field)
        name = camelize(field.name, False)
        stype = jtype_to_swift_type(field.fdef, 'C')
        item = codable_struct_item('public', 'var', name, stype, optional)
        items.append(item)
    return codable_struct(to_create_input(cdef), items)


def _class_update_input(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        if not _field_can_update(field):
            continue
        name = camelize(field.name, False)
        stype = jtype_to_swift_type(field.fdef, 'U')
        item = codable_struct_item('public', 'var', name, stype, True)
        items.append(item)
    return codable_struct(to_update_input(cdef), items)


def _class_query(cdef: Cdef) -> str:
    items: list[str] = []
    for field in cdef.fields:
        pass
    return codable_struct(to_query(cdef), items)


def to_create_input(cdef: Cdef) -> str:
    return cdef.name + 'CreateInput'


def to_update_input(cdef: Cdef) -> str:
    return cdef.name + 'UpdateInput'


def to_query(cdef: Cdef) -> str:
    return cdef.name + 'Query'


def _is_field_required_for_create(field: JField) -> bool:
    if _field_has_default(field):
        return False
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
    return field.fdef.read_rule != ReadRule.NO_READ
