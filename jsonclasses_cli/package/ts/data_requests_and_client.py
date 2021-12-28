from typing import cast
from jsonclasses.cdef import CDef
from jsonclasses_server.aconf import AConf
from .shared_utils import interface_required_include
from ...utils.join_lines import join_lines
from ...utils.package_utils import (
    class_needs_api, to_create_input, to_create_request, to_delete_request,
    to_id_request, to_list_query, to_list_request, to_result, to_result_picks, to_single_query,
    to_update_input, to_update_request, to_sort_orders, to_include
)

def data_requests_and_clients(cdef: CDef) -> str:
    if not class_needs_api(cdef):
        return ''
    aconf = cast(AConf, cdef.cls.aconf)
    return join_lines([
        _data_create_requet(cdef, aconf.name) if 'C' in aconf.actions else '',
        _data_update_request(cdef, aconf.name) if 'U' in aconf.actions else '',
        _data_delete_request(cdef, aconf.name) if 'D' in aconf.actions else '',
        _data_id_request(cdef, aconf.name) if 'R' in aconf.actions else '',
        _data_list_request(cdef, aconf.name),
        _data_client(cdef,aconf)
    ], 2)

def _data_query_request_common(cdef: CDef, request: str) -> str:
    return join_lines([f"""
pick(picks: {to_result_picks(cdef)}[]): {request}<Pick<T, typeof picks[number]>> {'{'}
    this.#query = {'{'}...this.#query, _pick: picks{'}'}
    return this
    {'}'}

    omit(omits: {to_result_picks(cdef)}[]): {request}<Omit<T, typeof omits[number]>> {'{'}
        this.#query = {'{'}...this.#query, _omit: omits{'}'}
        return this
    {'}'}
    """.strip('\n'), _data_query_request_includes(cdef, request)],0)

def _data_query_request_includes(cdef: CDef, request: str) -> str:
    if interface_required_include(cdef):
        return f""" 
    include(includes: {to_include(cdef)}[]): {request}<T> {'{'}
        this.#query = {'{'}...this.#query, _includes: includes {'}'}
        return this
    {'}'}
        """.strip('\n')
        
    return ''

def _data_create_requet(cdef:CDef, name:str) -> str:
    return f"""
class {to_create_request(cdef)}<T extends Partial<{to_result(cdef)}>> extends Promise<T> {'{'}
    #input: {to_create_input(cdef)}
    #query?: {to_single_query(cdef)}

    constructor(input: {to_create_input(cdef)}, query?:{to_single_query(cdef)}){'{'}
        super((resolve, reject) => {'{'}
            this.exec()
        {'}'})
        this.#input = input,
        this.#query = query
    {'}'}

    {_data_query_request_common(cdef,to_create_request(cdef))}
    async exec(): Promise<T> {'{'}
        return await RequestManager.share.post('/{name}', this.#input, this.#query)
    {'}'}
{'}'}
    """.strip() + "\n"

def _data_update_request(cdef:CDef, name:str) -> str:
    return f"""
class {to_update_request(cdef)}<T extends Partial<{to_result(cdef)}>> extends Promise<T> {'{'}
    #id: string
    #input: {to_update_input(cdef)}
    #query?: {to_single_query(cdef)}

    constructor(id:string, input: {to_update_input(cdef)}, query?: {to_single_query(cdef)},) {'{'}
        super((resolve, reject) => {'{'}
            this.exec()
        {'}'})
        this.#id = id
        this.#input = input,
        this.#query = query
    {'}'}

    {_data_query_request_common(cdef, to_update_request(cdef))}
    async exec(): Promise<User> {'{'}
        return await RequestManager.share.patch(`/{name}/${'{'}this.#id{'}'}`, this.#input, this.#query)
    {'}'}
{'}'}
""".strip() + "\n"

def _data_delete_request(cdef:CDef, name:str) -> str:
    return f"""
class {to_delete_request(cdef)} extends Promise<void> {'{'}
    #id: string

    constructor(id: string) {'{'}
        super((resolve, reject) => {'{'}
            this.exec()
        {'}'})
        this.#id = id
    {'}'}
    async exec(): Promise<void> {'{'}
        return await RequestManager.share.delete(`/{name}/${'{'}this.#id{'}'}`)
    {'}'}
{'}'}
""".strip() + "\n"

def _data_id_request(cdef:CDef, name:str) -> str:
    return f"""
class {to_id_request(cdef)}<T extends Partial<{to_result(cdef)}>> extends Promise<T> {'{'}
    #id: string
    #query?: {to_single_query(cdef)}

    constructor(id: string, query?: {to_single_query(cdef)}) {'{'}
        super((resolve, reject) => {'{'}
        this.exec()
    {'}'})
        this.#id = id,
        this.#query = query
    {'}'}

    {_data_query_request_common(cdef, to_id_request(cdef))}
    async exec(): Promise<User> {'{'}
        return await RequestManager.share.get(`/{name}/${'{'}this.#id{'}'}`, this.#query)
    {'}'}
{'}'}
""".strip() + "\n"

def _data_list_request(cdef:CDef, name:str) -> str:
    return f"""
class {to_list_request(cdef)}<T extends Partial<{to_result(cdef)}>> extends Promise<T[]> {'{'}
    #query?: {to_list_query(cdef)}

    constructor(query?: {to_list_query(cdef)}) {'{'}
        super((resolve,reject) => {'{'}
            this.exec()
        {'}'})
        this.#query = query
    {'}'}

    order(order: {to_sort_orders(cdef)} | {to_sort_orders(cdef)}[]): {to_list_request(cdef)}<T> {'{'}
        this.#query = {'{'}...this.#query, _order: order{'}'}
        return this
    {'}'}

    skip(skip: number): {to_list_request(cdef)}<T> {'{'}
        this.#query = {'{'}...this.#query, _skip: skip{'}'}
        return this
    {'}'}

    limt(limit: number): {to_list_request(cdef)}<T> {'{'}
        this.#query = {'{'}...this.#query, _limit:limit{'}'}
        return this
    {'}'}

    pageSize(pageSize: number): {to_list_request(cdef)}<T> {'{'}
        this.#query = {'{'}...this.#query, _pageSize: pageSize{'}'}
        return this
    {'}'}

    pageNo(pageNo: number): {to_list_request(cdef)}<T> {'{'}
        this.#query = {'{'}...this.#query, _pageNo: pageNo{'}'}
        return this
    {'}'}

    {_data_query_request_common(cdef, to_list_request(cdef))}
    exec(): Promise<User[]> {'{'}
        return RequestManager.share.get('/{name}',this.#query)
    {'}'}
{'}'}
""".strip() + "\n"

def _data_client(cdef: CDef, aconf: AConf) -> str:
    return f"""
class {cdef.name}Client {'{'}

    creat(input: {to_create_input(cdef)}, query?: {to_single_query(cdef)}): {to_create_request(cdef)}<User> {'{'}
        return new {to_create_request(cdef)}(input, query)
    {'}'}

    update(id: string, input: {to_update_input(cdef)}, query?: {to_single_query(cdef)}): {to_update_request(cdef)}<User> {'{'}
        return new {to_update_request(cdef)}(id, input, query)
{'}'}

    delete(id: string): {to_delete_request(cdef)} {'{'}
        return new {to_delete_request(cdef)}(id)
    {'}'}

    id(id: string, query?: {to_single_query(cdef)}) {'{'}
        return new {to_id_request(cdef)}(id, query)
    {'}'}

    find(query?: {to_list_query(cdef)}): {to_list_request(cdef)}<User> {'{'}
        return new {to_list_request(cdef)}(query)
    {'}'}
{'}'}
""".strip() + "\n"
