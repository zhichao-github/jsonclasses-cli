from typing import cast
from jsonclasses.cdef import Cdef
from jsonclasses_server.aconf import AConf

from jsonclasses_cli.utils.join_lines import join_lines
from ...utils.package_utils import (
    class_needs_api, class_needs_session, to_create_input, to_create_request, to_id_request, to_result_picks,
    to_single_query, to_update_input, to_result, to_update_request
)


def data_requests_and_clients(cdef: Cdef) -> str:
    if not class_needs_api(cdef):
        return ''
    aconf = cast(AConf, cdef.cls.aconf)
    return join_lines([
        _data_create_request(cdef, aconf.name) if 'C' in aconf.actions else '',
        _data_update_request(cdef, aconf.name) if 'U' in aconf.actions else '',
        _data_id_request(cdef, aconf.name) if 'R' in aconf.actions else ''
    ], 2)


def _data_single_request_common(cdef: Cdef) -> str:
    return f"""
    public mutating func pick(_ picks: [{to_result_picks(cdef)}]) -> Self {'{'}
        if query == nil {'{'} query = {to_single_query(cdef)}() {'}'}
        query = query!.pick(picks)
    {'}'}

    public mutating func pick(_ picks: [{to_result_picks(cdef)}]) async throws -> {to_result(cdef)} {'{'}
        self = self.pick(picks)
        return try await self.exec()
    {'}'}

    public mutating func omit(_ omits: [{to_result_picks(cdef)}]) -> Self {'{'}
        if query == nil {'{'} query = {to_single_query(cdef)}() {'}'}
        query = query!.omit(omits)
    {'}'}

    public mutating func omit(_ omits: [{to_result_picks(cdef)}]) async throws -> {to_result(cdef)} {'{'}
        self = self.omit(omits)
        return try await self.exec()
    {'}'}""".strip('\n')


def _data_create_request(cdef: Cdef, name: str) -> str:
    return join_lines([
        f"public struct {to_create_request(cdef)} {'{'}",
        f"    private var input: {to_create_input(cdef)}",
        f"    private var query: {to_single_query(cdef)}?",
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
        f"    private var id: String",
        f"    private var input: {to_update_input(cdef)}",
        f"    private var query: {to_single_query(cdef)}?",
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
        f"    private var id: String",
        f"    private var query: {to_single_query(cdef)}?",
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
