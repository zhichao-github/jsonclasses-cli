from typing import cast
from jsonclasses.cdef import Cdef
from jsonclasses_server.aconf import AConf
from jsonclasses_cli.package.swift.codable_class import CodableClassItem
from jsonclasses_cli.package.swift.shared_utils import class_create_input_items

from jsonclasses_cli.utils.join_lines import join_lines
from ...utils.package_utils import (
    class_needs_api, class_needs_session, to_create_input, to_create_request,
    to_id_request, to_list_query, to_list_request, to_list_result, to_result_picks, to_single_query,
    to_update_input, to_result, to_update_request, to_sort_orders, to_include
)


def data_requests_and_clients(cdef: Cdef) -> str:
    if not class_needs_api(cdef):
        return ''
    aconf = cast(AConf, cdef.cls.aconf)
    return join_lines([
        _data_create_request(cdef, aconf.name) if 'C' in aconf.actions else '',
        _data_update_request(cdef, aconf.name) if 'U' in aconf.actions else '',
        _data_id_request(cdef, aconf.name) if 'R' in aconf.actions else '',
        _data_find_request(cdef, aconf.name) if 'L' in aconf.actions else '',
        _data_client(cdef, aconf)
    ], 2)


def _data_find_request_nums(cdef: Cdef, method_name: str) -> str:
    return f"""
    public mutating func {method_name}(_ {method_name}: Int) -> {to_list_request(cdef)} {'{'}
        if query == nil {'{'} query = {to_list_query(cdef)}() {'}'}
        query = query!.{method_name}({method_name})
        return self
    {'}'}

    public mutating func {method_name}(_ {method_name}: Int) async throws -> [{to_result(cdef)}] {'{'}
        self = self.{method_name}({method_name})
        return try await self.exec()
    {'}'}""".strip('\n')


def _data_find_request_method(cdef: Cdef) -> str:
    return f"""
    public mutating func order(_ order: {to_sort_orders(cdef)}) -> {to_list_request(cdef)} {'{'}
        if query == nil {'{'} query = {to_list_query(cdef)}() {'}'}
        query = query!.order(order)
        return self
    {'}'}

    public mutating func order(_ orders: [{to_sort_orders(cdef)}]) -> {to_list_request(cdef)} {'{'}
        if query == nil {'{'} query = {to_list_query(cdef)}() {'}'}
        query = query!.order(orders)
        return self
    {'}'}

    public mutating func order(_ order: {to_sort_orders(cdef)}) async throws -> [{to_result(cdef)}] {'{'}
        self = self.order(order)
        return try await self.exec()
    {'}'}

    public mutating func order(_ orders: [{to_sort_orders(cdef)}]) async throws -> [{to_result(cdef)}] {'{'}
        self = self.order(orders)
        return try await self.exec()
    {'}'}

{join_lines(map(lambda n: _data_find_request_nums(cdef, n), ['skip', 'limit', 'pageSize', 'pageNo']), 2)}
    """.strip('\n')


def _data_single_request_common(cdef: Cdef, single: bool = True) -> str:
    return f"""
    public mutating func pick(_ picks: [{to_result_picks(cdef)}]) -> Self {'{'}
        if query == nil {'{'} query = {to_single_query(cdef) if single else to_list_query(cdef)}() {'}'}
        query = query!.pick(picks)
    {'}'}

    public mutating func pick(_ picks: [{to_result_picks(cdef)}]) async throws -> {to_result(cdef) if single else to_list_result(cdef)} {'{'}
        self = self.pick(picks)
        return try await self.exec()
    {'}'}

    public mutating func omit(_ omits: [{to_result_picks(cdef)}]) -> Self {'{'}
        if query == nil {'{'} query = {to_single_query(cdef) if single else to_list_query(cdef)}() {'}'}
        query = query!.omit(omits)
    {'}'}

    public mutating func omit(_ omits: [{to_result_picks(cdef)}]) async throws -> {to_result(cdef) if single else to_list_result(cdef)} {'{'}
        self = self.omit(omits)
        return try await self.exec()
    {'}'}""".strip('\n')


def _data_create_request(cdef: Cdef, name: str) -> str:
    return join_lines([
        f"public struct {to_create_request(cdef)} {'{'}",
        f"    internal var input: {to_create_input(cdef)}",
        f"    internal var query: {to_single_query(cdef)}?",
        '\n',
        f"    internal func exec() async throws -> {to_result(cdef)} {'{'}",
        f"        return try await RequestManager.shared.post(",
        f'            url: "/{name}", input: input, query: query',
        f"        )",
        "    }",
        '\n',
        _data_single_request_common(cdef),
        '}'
    ], 1)


def _data_update_request(cdef: Cdef, name: str) -> str:
    return join_lines([
        f"public struct {to_update_request(cdef)} {'{'}",
        f"    internal var id: String",
        f"    internal var input: {to_update_input(cdef)}",
        f"    internal var query: {to_single_query(cdef)}?",
        '\n',
        f"    internal func exec() async throws -> {to_result(cdef)} {'{'}",
        f"        return try await RequestManager.shared.patch(",
        f'            url: "/{name}/\(id)", input: input, query: query',
        f"        )",
        "    }",
        '\n',
        _data_single_request_common(cdef),
        '}'
    ], 1)


def _data_id_request(cdef: Cdef, name: str) -> str:
    return join_lines([
        f"public struct {to_id_request(cdef)} {'{'}",
        f"    internal var id: String",
        f"    internal var query: {to_single_query(cdef)}?",
        '\n',
        f"    internal func exec() async throws -> {to_result(cdef)} {'{'}",
        f"        return try await RequestManager.shared.get(",
        f'            url: "/{name}/\(id)", query: query',
        f"        )!",
        "    }",
        '\n',
        _data_single_request_common(cdef),
        '}'
    ], 1)


def _data_find_request(cdef: Cdef, name: str) -> str:
    return join_lines([
        f"public struct {to_list_request(cdef)} {'{'}",
        f"    internal var query: {to_list_query(cdef)}?",
        '\n',
        f"    internal func exec() async throws -> [{to_result(cdef)}] {'{'}",
        f"        return try await RequestManager.shared.get(",
        f'            url: "/{name}", query: query',
        f"        )!",
        "    }",
        '\n',
        _data_find_request_method(cdef),
        _data_single_request_common(cdef, False),
        '}'
    ], 1)


def _data_client(cdef: Cdef, aconf: AConf) -> str:
    return join_lines([
        'public struct UserClient {',
        '\n',
        '    fileprivate init() { }',
        '\n',
        join_lines([
            _data_client_creates(cdef, aconf),
            _data_client_updates(cdef, aconf),
            _data_client_delete(cdef, aconf),
            _data_client_ids(cdef, aconf),
            _data_client_finds(cdef, aconf),
        ], 2),
        '}'
    ], 1)


def _data_client_create_2(cdef: Cdef, items: list[CodableClassItem]) -> str:
    if len(items) == 0:
        return join_lines([
            f'    public func create() -> {to_create_request(cdef)} {"{"}',
            f'        let input = {to_create_input(cdef)}()',
            '        return create(input)',
            '    }'
        ], 1)
    last = len(items) - 1
    return join_lines([
        f'    public func create(',
        *map(lambda i: f"        {i[1][2]}: {i[1][3]}{'? = nil' if i[1][4] else ''}{'' if i[0] == last else ', '}", enumerate(items)),
        f'    ) -> {to_create_request(cdef)} {"{"}',
        f'        let input = {to_create_input(cdef)}(',
        *map(lambda i: f"            {i[1][2]}: {i[1][2]}{'' if i[0] == last else ','}", enumerate(items)),
        '        )',
        '        return create(input)',
        '    }'
    ], 1)


def _data_client_create_4(cdef: Cdef, items: list[CodableClassItem]) -> str:
    if len(items) == 0:
        return join_lines([
            f'    public func create() async throws -> {to_result(cdef)} {"{"}',
            f'        let request: {to_create_request(cdef)} = self.create()',
            '        return try await request.exec()',
            '    }'
        ], 1)
    last = len(items) - 1
    return join_lines([
        f'    public func create(',
        *map(lambda i: f"        {i[1][2]}: {i[1][3]}{'? = nil' if i[1][4] else ''}{'' if i[0] == last else ', '}", enumerate(items)),
        f'    ) async throws -> {to_result(cdef)} {"{"}',
        f'        let request: {to_create_request(cdef)} = self.create(',
        *map(lambda i: f"            {i[1][2]}: {i[1][2]}{'' if i[0] == last else ','}", enumerate(items)),
        '        )',
        '        return try await request.exec()',
        '    }'
    ], 1)


def _data_client_creates(cdef: Cdef, aconf: AConf) -> str:
    if 'C' not in aconf.actions:
        return ''
    input_items = class_create_input_items(cdef)
    return join_lines([
        f'    public func create(_ input: {to_create_input(cdef)}) -> {to_create_request(cdef)} {"{"}',
        f'        return {to_create_request(cdef)}(input: input)',
        '    }',
        '\n',
        _data_client_create_2(cdef, input_items),
        '\n',
        f'    public func create(_ input: {to_create_input(cdef)}) -> {to_create_request(cdef)} {"{"}',
        f'        let request: {to_create_request(cdef)} = self.create(input)',
        '        return try await request.exec()',
        '    }',
        '\n',
        _data_client_create_4(cdef, input_items)
    ], 1)


def _data_client_updates(cdef: Cdef, aconf: AConf) -> str:
    if 'U' not in aconf.actions:
        return ''
    return ''


def _data_client_delete(cdef: Cdef, aconf: AConf) -> str:
    if 'D' not in aconf.actions:
        return ''
    return ''


def _data_client_ids(cdef: Cdef, aconf: AConf) -> str:
    if 'R' not in aconf.actions:
        return ''
    return ''


def _data_client_finds(cdef: Cdef, aconf: AConf) -> str:
    if 'L' not in aconf.actions:
        return ''
    return ''
