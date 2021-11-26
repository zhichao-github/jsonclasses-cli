from jsonclasses.cgraph import CGraph

from jsonclasses_cli.package.test.session_input import session_input

from .session import session
from .session_items import session_items
from .data_interface import data_interface
from .string_query import string_query
from .number_query import number_query
from .boolean_query import boolean_query
from .date_query import date_query
from .data_enum import data_enum
from ...utils.join_lines import join_lines


def main_program_content(cgraph: CGraph) -> str:
    session_classes = session_items(cgraph)
    use_session = len(session_classes) > 0
    return join_lines([
        _import_lines(),
        *map(lambda e: data_enum(e), cgraph._enum_map.values()),
        string_query(),
        number_query(),
        boolean_query(),
        date_query(),
        *map(lambda c: data_interface(c), cgraph._map.values()),
        *map(lambda c: session_input(c), cgraph._map.values()),
        session(session_classes)
    ], 3)


def _import_lines() -> str:
    return """
import axios from 'axios'
import { stringify } from 'qsparser-js'
    """.strip()
