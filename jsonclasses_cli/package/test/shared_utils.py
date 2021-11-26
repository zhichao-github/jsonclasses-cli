from inflection import camelize
from jsonclasses.cdef import Cdef
from jsonclasses.jfield import JField
from jsonclasses.fdef import (
    FStore, FType, Nullability, ReadRule, Queryability, WriteRule
)
from jsonclasses.modifiers.required_modifier import RequiredModifier
from jsonclasses.modifiers.default_modifier import DefaultModifier
from .jtype_to_ts_type import jtype_to_ts_type


def list_query_items(cdef: Cdef) -> list[tuple[str, str]]:
    items: list[tuple[str, str]] = []
    for field in cdef.fields:
        if not is_field_queryable(field):
            continue
        name = camelize(field.name, False)
        type = jtype_to_ts_type(field.fdef, 'Q')
        if is_field_ref(field):
            continue
        else:
            items.append((name, type))
    return items


def is_field_local_key(field: JField) -> bool:
    return field.fdef.fstore == FStore.LOCAL_KEY


def is_field_required_for_create(field: JField) -> bool:
    if field_has_default(field):
        return False
    if is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)


def is_field_required_null_for_update(field: JField):
    if is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)


def field_ref_id_name(field: JField) -> str:
    rkes = field.cdef.jconf.ref_key_encoding_strategy
    kes = field.cdef.jconf.key_encoding_strategy
    return kes(rkes(field))


def field_has_default(field: JField) -> bool:
    if is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, DefaultModifier)), False)


def is_field_nonnull(field: JField) -> bool:
    if field.fdef.ftype == FType.LIST:
        if field.fdef.fstore == FStore.LOCAL_KEY or field.fdef.fstore == FStore.FOREIGN_KEY:
            if field.fdef.collection_nullability == Nullability.NONNULL:
                return True
    return False


def is_field_primary(field: JField) -> bool:
    return field.fdef.primary


def is_field_ref(field: JField) -> bool:
    if field.fdef.fstore == FStore.LOCAL_KEY:
        return True
    if field.fdef.fstore == FStore.FOREIGN_KEY:
        return True
    return False


def is_field_required_for_read(field: JField) -> bool:
    if is_field_nonnull(field):
        return True
    return next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)


def is_field_queryable(field: JField) -> bool:
    if field.fdef.read_rule == ReadRule.NO_READ:
        return False
    if field.fdef.fstore == FStore.TEMP:
        return False
    return field.fdef.queryability != Queryability.UNQUERYABLE


def field_can_create(field: JField) -> bool:
    return field.fdef.write_rule != WriteRule.NO_WRITE


def field_can_update(field: JField) -> bool:
    if field.fdef.write_rule == WriteRule.NO_WRITE:
        return False
    if field.fdef.write_rule == WriteRule.WRITE_ONCE:
        if is_field_required_for_create(field):
            return False
    return True


def field_can_read(field: JField) -> bool:
    if field.fdef.read_rule == ReadRule.NO_READ:
        return False
    if field.fdef.fstore == FStore.TEMP:
        return False
    return True


def class_required_include(cdef: Cdef) -> bool:
    items = [f for f in cdef.fields if is_field_ref(f)]
    return len(items) > 0


def is_list_field(field: JField) -> bool:
    return field.fdef.ftype == FType.LIST


def to_include_name(cname: str, name: str) -> str:
    return cname + camelize(name) + 'Include'


def string(val: str) -> str:
    return "'" +val +"'"
