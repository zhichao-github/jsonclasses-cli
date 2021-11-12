from pathlib import Path
from typing import Literal
from inflection import camelize
from jsonclasses.cdef import Cdef
from jsonclasses.cgraph import CGraph
from jsonclasses.fdef import FStore, Fdef, FType, Nullability, Queryability, ReadRule, WriteRule
from jsonclasses.jfield import JField
from jsonclasses.modifiers.required_modifier import RequiredModifier
from jsonclasses.modifiers.default_modifier import DefaultModifier


def ts(dest: Path, cgraph: CGraph):
    dest = dest / 'packages' / 'ts'
    if not dest.is_dir():
        dest.mkdir(parents=True)
    import_line = _import_line()
    interfaces = _gen_interfaces(cgraph, cgraph._map)
    file_content = "\n".join([import_line, interfaces])
    with open(str(dest / 'index.ts'), 'w') as file:
        file.write(file_content)


def _gen_idref_modify(idtype: str) -> str:
    add = 'interface RefListAdd {\n' + f'    _add: {idtype}' + '}'
    rem = 'interface RefListDel {\n' + f'    _del: {idtype}' + '}'
    typ = 'type RefListItem = RefListAdd | RefListDel'
    return add + '\n\n' + rem + '\n\n' + typ + '\n\n'


def _gen_interface(name: str, items: dict[str, str]) -> str:
    return 'interface ' + name + '{\n' + "\n".join(["    " + k + ": " + v for k, v in items.items()]) + '\n}\n\n'


def _gen_query_interface(name: str, items: dict[str, str]) -> str:
    items.update({ # order, include, pick, omit
        '_pageSize?': 'number',
        '_pageNumber?': 'number',
        '_skip?': 'number',
        '_limit?': 'number'
    })
    return _gen_interface(name, items)


def _gen_queries(query_names: list[str]) -> str:
    retval = ''
    if 'StringQuery' in query_names:
        retval += _string_query() + '\n'
    if 'NumberQuery' in query_names:
        retval += _number_query() + '\n'
    if 'BoolQuery' in query_names:
        retval += _boolean_query() + '\n'
    if 'DateQuery' in query_names:
        retval += _date_query() + '\n'
    return retval


def _gen_interfaces(cgraph: CGraph, cmap: dict[str, Cdef]) -> str:
    required_enums: list[str] = []
    required_queries: list[str] = []
    use_idref_modify: bool = False
    retval = ''
    for (name, cdef) in cmap.items():
        if not hasattr(cdef.cls, 'aconf'):
            continue
        result_name = name
        result = {}
        create_name = name + 'CreateInput'
        create = {}
        update_name = name + 'UpdateInput'
        update = {}
        query_name = name + 'Query'
        query = {}
        for field in cdef.fields:
            required = next((True for v in field.types.modifier.vs if isinstance(v, RequiredModifier)), False)
            has_default = next((True for v in field.types.modifier.vs if isinstance(v, DefaultModifier)), False)
            nonnull = False
            if field.fdef.ftype == FType.ENUM:
                required_enums.append(field.fdef.enum_class.__name__)
            if field.fdef.ftype == FType.LIST:
                if field.fdef.fstore == FStore.LOCAL_KEY or field.fdef.fstore == FStore.FOREIGN_KEY:
                    if field.fdef.collection_nullability == Nullability.NONNULL:
                        required = True
                        has_default = True
                        nonnull = True
            if field.fdef.read_rule != ReadRule.NO_READ:
                if field.fdef.fstore != FStore.TEMP:
                    result[field.json_name + '' if required else '?'] = _ts_type(field.fdef, 'R')
                    if field.fdef.fstore == FStore.LOCAL_KEY:
                        rkes = cdef.jconf.ref_key_encoding_strategy
                        idname = cdef.jconf.key_encoding_strategy(rkes(field))
                        idtype = _ts_type(cdef.primary_field.fdef.ftype, 'R') + '[]' if field.fdef.ftype == FType.LIST else ''
                        result[idname] = idtype
            if field.fdef.write_rule != WriteRule.NO_WRITE:
                only_create = required and field.fdef.write_rule == WriteRule.WRITE_ONCE
                create_optional = (not required) or has_default
                no_input = field.fdef.fstore == FStore.CALCULATED and field.fdef.setter is None
                if not no_input:
                    create[field.json_name + '?' if create_optional else ''] = _ts_type(field.fdef, 'C')
                    if field.fdef.fstore == FStore.LOCAL_KEY:
                        rkes = cdef.jconf.ref_key_encoding_strategy
                        idname = cdef.jconf.key_encoding_strategy(rkes(field))
                        idtype = _ts_type(cdef.primary_field.fdef.ftype, 'C') + '[]' if field.fdef.ftype == FType.LIST else ''
                        create[idname] = idtype
                    if not only_create:
                        update[field.json_name + '?'] = _ts_type(field.fdef, 'U') + '' if required or nonnull else ' | null'
                        if field.fdef.fstore == FStore.LOCAL_KEY:
                            rkes = cdef.jconf.ref_key_encoding_strategy
                            idname = cdef.jconf.key_encoding_strategy(rkes(field))
                            idtype = _ts_type(cdef.primary_field.fdef.ftype, 'U') + '[]' if field.fdef.ftype == FType.LIST else ('' if required else ' | null')
                            update[idname] = idtype
            if field.fdef.queryability != Queryability.UNQUERYABLE:
                qtype = _ts_type(field.fdef, 'Q')
                query[field.json_name + '?'] = qtype
                if qtype.endswith('Query'):
                    if qtype not in required_queries:
                        required_queries.append(qtype)
        result_interface = _gen_interface(result_name, result)
        create_interface = _gen_interface(create_name, create)
        update_interface = _gen_interface(update_name, update)
        query_interface = _gen_query_interface(query_name, query)
        retval = retval + _gen_enum_interfaces(cgraph, required_enums) + '\n'
        retval = retval + _gen_queries(required_queries) + '\n'
        retval = retval + result_interface + '\n' + create_interface + '\n' + update_interface + '\n' + query_interface + '\n'
    print(retval)
    return retval

def _gen_enum_interfaces(cgraph: CGraph, enum_names: list[str]) -> str:
    interfaces: list[str] = []
    for name in enum_names:
        enum_cls = cgraph._enum_map[name]
        line_one = 'enum ' + name + ' {\n'
        last_line = '}\n'
        lines: list[str] = []
        for option in enum_cls:
            ts_val = option.name
            ts_name = camelize(option.name.lower())
            lines.append('    ' + ts_name + ' = ' + "'" + ts_val + "',\n")
        interfaces.append(line_one + "".join(lines) + last_line)
    return "\n".join(interfaces)

def _ts_type(fdef: Fdef, mode: Literal['C', 'U', 'R', 'Q']) -> str:
    match fdef.ftype:
        case FType.STR:
            if mode == 'Q':
                return 'StringQuery'
            else:
                return 'string'
        case FType.INT:
            if mode == 'Q':
                return 'NumberQuery'
            else:
                return 'number'
        case FType.FLOAT:
            if mode == 'Q':
                return 'NumberQuery'
            else:
                return 'number'
        case FType.BOOL:
            if mode == 'Q':
                return 'BooleanQuery'
            else:
                return 'boolean'
        case FType.DATE:
            if mode == 'Q':
                return 'DateQuery'
            elif mode == 'R':
                return 'string'
            else:
                return 'Date'
        case FType.DATETIME:
            if mode == 'Q':
                return 'DateQuery'
            elif mode == 'R':
                return 'string'
            else:
                return 'Date'
        case FType.ENUM:
            return fdef.enum_class.__name__
        case FType.LIST:
            return _ts_type(fdef.item_types.fdef, mode) + '[]'
        case FType.DICT:
            return '{[key: string]: ' + _ts_type(fdef.item_types.fdef, mode) + '}'
        case FType.INSTANCE:
            if mode == 'R':
                return fdef.inst_cls.__name__
            elif mode == 'C':
                return fdef.inst_cls.__name__ + 'CreateInput'
            elif mode == 'U':
                return fdef.inst_cls.__name__ + 'UpdateInput'
        case FType.ANY:
            return 'any'
        case FType.UNION:
            return " | ".join([_ts_type(t, mode) for t in fdef.raw_union_types])
        case None:
            return "never"


def _string_query() -> str:
    return ('interface StringContainsQuery {\n'
        '    _contains: string\n'
        '}\n'
        '\n'
        'interface StringPrefixQuery {\n'
        '    _prefix: string\n'
        '}\n'
        '\n'
        'interface StringSuffixQuery {\n'
        '    _suffix: string\n'
        '}\n'
        '\n'
        'interface StringMatchQuery {\n'
        '    _match: string\n'
        '}\n'
        '\n'
        'interface StringContainsiQuery {\n'
        '    _containsi: string\n'
        '}\n'
        '\n'
        'interface StringPrefixiQuery {\n'
        '    _prefixi: string\n'
        '}\n'
        '\n'
        'interface StringSuffixiQuery {\n'
        '    _suffixi: string\n'
        '}\n'
        '\n'
        'interface StringMatchiQuery {\n'
        '    _matchi: string\n'
        '}\n'
        '\n'
        'export type StringQuery = string | StringContainsQuery | StringPrefixQuery | StringSuffixQuery | StringMatchQuery | StringContainsiQuery | StringPrefixiQuery | StringSuffixiQuery | StringMatchiQuery\n'
        )


def _number_query() -> str:
    return ('interface NumberValueQuery {\n'
        '    _gt?: number\n'
        '    _gte?: number\n'
        '    _lt?: number\n'
        '    _lte?: number\n'
        '}\n'
        '\n'
        'export type NumberQuery = number | NumberValueQuery\n'
        )


def _boolean_query() -> str:
    return (
        'export type BooleanQuery = boolean\n'
        )


def _date_query() -> str:
    return ('interface DateValueQuery {\n'
        '    _gt?: Date\n'
        '    _gte?: Date\n'
        '    _lt?: Date\n'
        '    _lte?: Date\n'
        '    _on?: Date\n'
        '}\n'
        '\n'
        'export type DateQuery = Date | DateValueQuery\n'
        )


def _import_line() -> str:
    return """import axios from 'axios'\nimport { stringify } from 'qsparser-js'\n"""
