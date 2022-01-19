import axios from 'axios'
import { stringify } from 'qsparser-js'


type Mode = 'default' | 'insensitive'

interface StringContainsQuery {
    _contains: string
    _mode?: Mode
}

interface StringPrefixQuery {
    _prefix: string
    _mode?: Mode
}

interface StringSuffixQuery {
    _suffix: string
    _mode?: Mode
}

interface StringMatchQuery {
    _match: string
    _mode?: Mode
}

interface StringEqQuery {
    _eq: string
}

interface StringNeqQuery {
    _neq: string
}

interface StringNullQuery {
    _null: boolean
}

interface StringCompareQuery {
    _gt?: string
    _gte?: string
    _lt?: string
    _lte?: string
}

interface StringOrQuery {
    _or: StringQuery[]
}

interface StringAndQuery {
    _and: StringQuery[]
}

export type StringQuery = string | StringContainsQuery | StringPrefixQuery | StringSuffixQuery | StringMatchQuery |
                          StringEqQuery | StringNeqQuery | StringNullQuery | StringCompareQuery | StringOrQuery | StringAndQuery


interface NumberValueQuery {
    _gt?: number
    _gte?: number
    _lt?: number
    _lte?: number
}

interface NumberEqQuery {
    _eq: number
}

interface NumberNeqQuery {
    _neq: number
}

interface NumberNullQuery {
    _null: boolean
}

interface NumberOrQuery {
    _or: NumberQuery[]
}

interface NumberAndQuery {
    _and: NumberQuery[]
}

export type NumberQuery = number | NumberEqQuery | NumberNeqQuery | NumberNullQuery | NumberValueQuery | NumberOrQuery | NumberAndQuery


interface BooleanEqQuery {
    _eq: boolean
}

interface BooleanNeqQuery {
    _neq: boolean
}

interface BooleanNullQuery {
    _null: boolean
}

interface BooleanOrQuery {
    _or: BooleanQuery[]
}

interface BooleanAndQuery {
    _and: BooleanQuery[]
}

export type BooleanQuery = boolean | BooleanEqQuery | BooleanNeqQuery | BooleanNullQuery | BooleanOrQuery | BooleanAndQuery


interface DateValueQuery {
    _gt?: Date
    _gte?: Date
    _lt?: Date
    _lte?: Date
    _on?: Date
}

interface DateEqQuery {
    _eq: Date
}

interface DateNeqQuery {
    _neq: Date
}

interface DateNullQuery {
    _null: boolean
}

interface DateOrQuery {
    _or: DateQuery[]
}

interface DateAndQuery {
    _and: DateQuery[]
}

interface DateBeforeQuery {
    _before: Date
}

interface DateAfterQuery {
    _after: Date
}

export type DateQuery = Date | DateValueQuery | DateEqQuery | DateNeqQuery | DateNullQuery | DateOrQuery | DateAndQuery |
                        DateBeforeQuery | DateAfterQuery


interface IDQuery {
    _eq: String
    _neq: String
    _null: boolean
}


interface Link {
    _add: String
}

interface UnLink {
    _del: String
}


export interface SimpleSong {
    id: string
    name: string
    createdAt: string
    updatedAt: string
}

export interface SimpleSongCreateInput {
    name: string
}

export interface SimpleSongUpdateInput {
    name?: string
}

type SimpleSongSortOrder = 'name' | '-name' | 'createdAt' | '-createdAt' | 'updatedAt' | '-updatedAt'

type SimpleSongResultPick = 'id' | 'name' | 'createdAt' | 'updatedAt'

interface SimpleSongSingleQuery {
    _pick?: SimpleSongResultPick[]
    _omit?: SimpleSongResultPick[]
}

interface SimpleSongListQuery {
    id?: StringQuery
    name?: StringQuery
    createdAt?: DateQuery
    updatedAt?: DateQuery
    _order?: SimpleSongSortOrder | SimpleSongSortOrder[]
    _limit?: number
    _skip?: number
    _pageNo?: number
    _pageSize?: number
    _pick?: SimpleSongResultPick[]
    _omit?: SimpleSongResultPick[]
}

interface SimpleSongSeekQuery {
    id?: StringQuery
    name?: StringQuery
    createdAt?: DateQuery
    updatedAt?: DateQuery
}

interface SimpleSongQueryData {
    _query: SimpleSongSeekQuery
    _data: SimpleSongUpdateInput
}


class RequestManager {

    static share = new RequestManager()

    #baseURL: string = "None"


    get headers() {
        const token = undefined
        return token ? {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        } : undefined
    }

    qs(val: any): string {
        if (!val) {
            return ''
        }
        if (Object.keys(val).length === 0) {
            return ''
        }
        return '?' + stringify(val)
    }

    async post<T, U, V>(url: string, input: T, query: V | undefined = undefined): Promise<U> {
        const response = await axios.post(this.#baseURL + url + this.qs(query), input, this.headers)
        return response.data.data
    }

    async patch<T, U, V>(url: string, input: T, query: V | undefined = undefined): Promise<U> {
        const response = await axios.patch(this.#baseURL + url + this.qs(query), input, this.headers)
        return response.data.data
    }

    async delete<V>(url: string, query: V | undefined = undefined): Promise<void> {
        await axios.delete(this.#baseURL + url + this.qs(query), this.headers)
        return
    }

    async get<U, V>(url: string, query: V | undefined = undefined): Promise<U> {
        const response = await axios.get(this.#baseURL + url + this.qs(query), this.headers)
        return response.data.data
    }
}


class SimpleSongCreateRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #input: SimpleSongCreateInput
    #query?: SimpleSongSingleQuery

    constructor(input: SimpleSongCreateInput, query?:SimpleSongSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongCreateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongCreateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<T> {
        return await RequestManager.share.post('/simple-songs', this.#input, this.#query)
    }
}

class SimpleSongUpdateRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #id: string
    #input: SimpleSongUpdateInput
    #query?: SimpleSongSingleQuery

    constructor(id:string, input: SimpleSongUpdateInput, query?: SimpleSongSingleQuery,) {
        super(() => {})
        this.#id = id
        this.#input = input
        this.#query = query
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongUpdateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongUpdateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<SimpleSong> {
        return await RequestManager.share.patch(`/simple-songs/${this.#id}`, this.#input, this.#query)
    }
}

class SimpleSongDeleteRequest extends Promise<void> {

    #id: string

    constructor(id: string) {
        super(() => {})
        this.#id = id
    }
    async exec(): Promise<void> {
        return await RequestManager.share.delete(`/simple-songs/${this.#id}`)
    }
}

class SimpleSongIDRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #id: string
    #query?: SimpleSongSingleQuery

    constructor(id: string, query?: SimpleSongSingleQuery) {
        super(() => {})
        this.#id = id,
        this.#query = query
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongIDRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongIDRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<SimpleSong> {
        return await RequestManager.share.get(`/simple-songs/${this.#id}`, this.#query)
    }
}

class SimpleSongUpsertRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #input: SimpleSongQueryData

    constructor(input: SimpleSongQueryData){
        super(() => {})
        this.#input = input
    }

    async exec(): Promise<T> {
        return await RequestManager.share.post('/simple-songs', { '_upsert': this.#input })
    }
}
    

class SimpleSongCreateManyRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #input: SimpleSongCreateInput[]
    #query?: SimpleSongSingleQuery

     constructor(input: SimpleSongCreateInput[], query?:SimpleSongSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongCreateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongCreateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<T[]> {
        return await RequestManager.share.post('/simple-songs', { '_create': this.#input })
    }
}
    

class SimpleSongUpdateManyRequest<T extends Partial<SimpleSong>> extends Promise<T> {

    #input: SimpleSongQueryData
    #query?: SimpleSongSingleQuery

    constructor(input: SimpleSongQueryData, query?:SimpleSongSingleQuery) {
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongUpdateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongUpdateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<SimpleSong> {
        return await RequestManager.share.patch('/simple-songs', { '_update': this.#input })
    }
}
    

class SimpleSongDeleteManyRequest extends Promise<void> {

    #query?: SimpleSongSeekQuery

    constructor(query?: SimpleSongSeekQuery) {
        super(() => {})
        this.#query = query
    }

    async exec(): Promise<void> {
        return await RequestManager.share.delete('/simple-songs', this.#query)
    }
}
    

class SimpleSongListRequest<T extends Partial<SimpleSong>> extends Promise<T[]> {

    #query?: SimpleSongListQuery

    constructor(query?: SimpleSongListQuery) {
        super(() => {})
        this.#query = query
    }

    order(order: SimpleSongSortOrder | SimpleSongSortOrder[]): SimpleSongListRequest<T> {
        this.#query = {...this.#query, _order: order}
        return this
    }

    skip(skip: number): SimpleSongListRequest<T> {
        this.#query = {...this.#query, _skip: skip}
        return this
    }

    limt(limit: number): SimpleSongListRequest<T> {
        this.#query = {...this.#query, _limit:limit}
        return this
    }

    pageSize(pageSize: number): SimpleSongListRequest<T> {
        this.#query = {...this.#query, _pageSize: pageSize}
        return this
    }

    pageNo(pageNo: number): SimpleSongListRequest<T> {
        this.#query = {...this.#query, _pageNo: pageNo}
        return this
    }

    pick(picks: SimpleSongResultPick[]): SimpleSongListRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: SimpleSongResultPick[]): SimpleSongListRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    
    async exec(): Promise<SimpleSong[]> {
        return await RequestManager.share.get('/simple-songs',this.#query)
    }
}

class SimpleSongClient {

    create(input: SimpleSongCreateInput, query?: SimpleSongSingleQuery): SimpleSongCreateRequest<SimpleSong> {
        return new SimpleSongCreateRequest(input, query)
    }

    createMany(input: SimpleSongCreateInput[]): SimpleSongCreateManyRequest<SimpleSong> {
        return new SimpleSongCreateManyRequest(input)
    }

    id(id: string, query?: SimpleSongSingleQuery) {
        return new SimpleSongIDRequest(id, query)
    }

    update(id: string, input: SimpleSongUpdateInput, query?: SimpleSongSingleQuery): SimpleSongUpdateRequest<SimpleSong> {
        return new SimpleSongUpdateRequest(id, input, query)
    }

    upsert(input: SimpleSongQueryData): SimpleSongUpsertRequest<SimpleSong> {
        return new SimpleSongUpsertRequest(input)
    }

    updateMany(input: SimpleSongQueryData): SimpleSongUpdateManyRequest<SimpleSong> {
        return new SimpleSongUpdateManyRequest(input)
    }

    find(query?: SimpleSongListQuery): SimpleSongListRequest<SimpleSong> {
        return new SimpleSongListRequest(query)
    }

    delete(id: string): SimpleSongDeleteRequest {
        return new SimpleSongDeleteRequest(id)
    }

    deleteMany(query?: SimpleSongSeekQuery): SimpleSongDeleteManyRequest {
        return new SimpleSongDeleteManyRequest(query)
    }

}


class API {

    get simpleSongs(): SimpleSongClient {
        return new SimpleSongClient()
    }

}


export const api = new API()


