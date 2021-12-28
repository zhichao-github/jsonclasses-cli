from jsonclasses.cgraph import CGraph

from jsonclasses_cli.package.ts.data_requests_and_client import data_requests_and_clients
from .request_manager import request_manager
from .session_manager import session_manager
from .session_input import session_input
from .session import session
from .session_items import session_items
from .data_interface import data_interface
from .string_query import string_query
from .number_query import number_query
from .boolean_query import boolean_query
from .date_query import date_query
from .data_enum import data_enum
from ...utils.join_lines import join_lines
from ...utils.package_utils import session_input_cdefs


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
        *map(lambda c: session_input(c), session_input_cdefs(cgraph)),
        session(session_classes),
        session_manager(session_classes) if use_session else '',
        request_manager('http://127.0.0.1:5000'),
        *map(lambda c: data_requests_and_clients(c), cgraph._map.values()),
    ], 3)


def _import_lines() -> str:
    return """
import axios from 'axios'
import { stringify } from 'qsparser-js'
    """.strip()
