from typing import Literal
from jsonclasses.fdef import FStore, FType, FDef


def jtype_to_ts_type(fdef: FDef, mode: Literal['C', 'U', 'R', 'Q'], is_link: bool = False) -> str:
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
            return jtype_to_ts_type(fdef.item_types.fdef, mode, is_field_link(fdef)) + '[]'
        case FType.DICT:
            return '{[key: string]: ' + jtype_to_ts_type(fdef.item_types.fdef, mode) + '}'
        case FType.INSTANCE:
            if mode == 'R':
                return fdef.inst_cls.__name__
            elif mode == 'C':
                result = fdef.inst_cls.__name__ + 'CreateInput'
                if is_link:
                    return f'({result} | Link)'
                return result
            elif mode == 'U':
                result = fdef.inst_cls.__name__ + 'UpdateInput'
                if is_link:
                    return f'({result} | Link | UnLink)'
                return result
            else:
                return 'never'
        case FType.ANY:
            return 'any'
        case FType.UNION:
            return " | ".join([jtype_to_ts_type(t.fdef, mode) for t in fdef.raw_union_types])
        case None:
            return "never"

def is_field_link(fdef: FDef) -> bool:
    return fdef.fstore == FStore.LOCAL_KEY or fdef.use_join_table
