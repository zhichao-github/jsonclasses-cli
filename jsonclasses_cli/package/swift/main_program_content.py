from jsonclasses.cgraph import CGraph
from .import_lines import import_lines
from .string_query import string_query
from .sort_order import sort_order
from .data_enum import data_enum
from ...utils.join_lines import join_lines


def main_program_content(cgraph: CGraph) -> str:
    return join_lines([
        import_lines(),
        string_query(),
        sort_order(),
        # other type queries
        *map(lambda e: data_enum(e), cgraph._enum_map.values())
    ], 2)
