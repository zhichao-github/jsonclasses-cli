from typing import cast
from jsonclasses.cdef import Cdef
from jsonclasses_server.aconf import AConf

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
        _data_find_request(cdef, aconf.name) if 'L' in aconf.actions else ''
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
