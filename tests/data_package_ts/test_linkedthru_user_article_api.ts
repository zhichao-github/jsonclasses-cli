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


export interface User {
    id: string
    username: string
    phoneNum?: string
    articles: Article[]
}

export interface UserCreateInput {
    username: string
    password: string
    phoneNum?: string
    articles: (ArticleCreateInput | Link)[]
}

export interface UserUpdateInput {
    username?: string
    password?: string
    phoneNum?: string | null
    articles?: (ArticleUpdateInput | Link | UnLink)[]
}

type UserSortOrder = 'username' | '-username' | 'phoneNum' | '-phoneNum'

type UserResultPick = 'id' | 'username' | 'phoneNum' | 'articles'

interface UserArticlesInclude {
    articles?: ArticleListQuery
}

type UserInclude = UserArticlesInclude

interface UserSingleQuery {
    _pick?: UserResultPick[]
    _omit?: UserResultPick[]
    _includes?: UserInclude[]
}

interface UserListQuery {
    id?: StringQuery
    username?: StringQuery
    phoneNum?: StringQuery
    _order?: UserSortOrder | UserSortOrder[]
    _limit?: number
    _skip?: number
    _pageNo?: number
    _pageSize?: number
    _pick?: UserResultPick[]
    _omit?: UserResultPick[]
    _includes?: UserInclude[]
}

interface UserSeekQuery {
    id?: StringQuery
    username?: StringQuery
    phoneNum?: StringQuery
}

interface UserQueryData {
    _query: UserSeekQuery
    _data: UserUpdateInput
}


export interface Article {
    id: string
    title: string
    content?: string
    users: User[]
}

export interface ArticleCreateInput {
    title: string
    content?: string
    users: (UserCreateInput | Link)[]
}

export interface ArticleUpdateInput {
    title?: string
    content?: string | null
    users?: (UserUpdateInput | Link | UnLink)[]
}

type ArticleSortOrder = 'title' | '-title' | 'content' | '-content'

type ArticleResultPick = 'id' | 'title' | 'content' | 'users'

interface ArticleUsersInclude {
    users?: UserListQuery
}

type ArticleInclude = ArticleUsersInclude

interface ArticleSingleQuery {
    _pick?: ArticleResultPick[]
    _omit?: ArticleResultPick[]
    _includes?: ArticleInclude[]
}

interface ArticleListQuery {
    id?: StringQuery
    title?: StringQuery
    content?: StringQuery
    _order?: ArticleSortOrder | ArticleSortOrder[]
    _limit?: number
    _skip?: number
    _pageNo?: number
    _pageSize?: number
    _pick?: ArticleResultPick[]
    _omit?: ArticleResultPick[]
    _includes?: ArticleInclude[]
}

interface ArticleSeekQuery {
    id?: StringQuery
    title?: StringQuery
    content?: StringQuery
}

interface ArticleQueryData {
    _query: ArticleSeekQuery
    _data: ArticleUpdateInput
}


interface UserSessionInput {
    username: string
    password: string
}


interface UserSession {
    token: string
    user: User
}


class SessionManager {

    #sessionKey = '_jsonclasses_session'
    #session: UserSession | undefined

    static share = new SessionManager()

    constructor() {
        const item = localStorage.getItem(this.#sessionKey)
        if (item && item !== null && item !== '') {
            this.#session = JSON.parse(item)
        } else {
            this.#session = undefined
        }
    }

    setSession(session: UserSession | undefined | null) {
        if (session) {
            this.#session = session
            localStorage.setItem(this.#sessionKey, JSON.stringify(session))
        } else {
            this.#session = undefined
            localStorage.removeItem(this.#sessionKey)
        }
    }

    hasSession(): boolean {
        return this.#session !== undefined
    }

    getToken(): string | undefined {
        return this.#session?.token
    }

    getSession(): UserSession | undefined {
        return this.#session
    }

    clearSession() {
        this.#session = undefined
        localStorage.removeItem(this.#sessionKey)
    }
}


class RequestManager {

    static share = new RequestManager()

    #baseURL: string = "None"


    get headers() {
        const token = SessionManager.share.hasSession() ? SessionManager.share.getToken() :  undefined 
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


class UserCreateRequest<T extends Partial<User>> extends Promise<T> {

    #input: UserCreateInput
    #query?: UserSingleQuery

    constructor(input: UserCreateInput, query?:UserSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserCreateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserCreateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserCreateRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<T> {
        return await RequestManager.share.post('/users', this.#input, this.#query)
    }
}

class UserUpdateRequest<T extends Partial<User>> extends Promise<T> {

    #id: string
    #input: UserUpdateInput
    #query?: UserSingleQuery

    constructor(id:string, input: UserUpdateInput, query?: UserSingleQuery,) {
        super(() => {})
        this.#id = id
        this.#input = input
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserUpdateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserUpdateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserUpdateRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<User> {
        return await RequestManager.share.patch(`/users/${this.#id}`, this.#input, this.#query)
    }
}

class UserDeleteRequest extends Promise<void> {

    #id: string

    constructor(id: string) {
        super(() => {})
        this.#id = id
    }
    async exec(): Promise<void> {
        return await RequestManager.share.delete(`/users/${this.#id}`)
    }
}

class UserIDRequest<T extends Partial<User>> extends Promise<T> {

    #id: string
    #query?: UserSingleQuery

    constructor(id: string, query?: UserSingleQuery) {
        super(() => {})
        this.#id = id,
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserIDRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserIDRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserIDRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<User> {
        return await RequestManager.share.get(`/users/${this.#id}`, this.#query)
    }
}

class UserUpsertRequest<T extends Partial<User>> extends Promise<T> {

    #input: UserQueryData

    constructor(input: UserQueryData){
        super(() => {})
        this.#input = input
    }

    async exec(): Promise<T> {
        return await RequestManager.share.post('/users', { '_upsert': this.#input })
    }
}
    

class UserCreateManyRequest<T extends Partial<User>> extends Promise<T> {

    #input: UserCreateInput[]
    #query?: UserSingleQuery

     constructor(input: UserCreateInput[], query?:UserSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserCreateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserCreateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserCreateManyRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<T[]> {
        return await RequestManager.share.post('/users', { '_create': this.#input })
    }
}
    

class UserUpdateManyRequest<T extends Partial<User>> extends Promise<T> {

    #input: UserQueryData
    #query?: UserSingleQuery

    constructor(input: UserQueryData, query?:UserSingleQuery) {
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserUpdateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserUpdateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserUpdateManyRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<User> {
        return await RequestManager.share.patch('/users', { '_update': this.#input })
    }
}
    

class UserDeleteManyRequest extends Promise<void> {

    #query?: UserSeekQuery

    constructor(query?: UserSeekQuery) {
        super(() => {})
        this.#query = query
    }

    async exec(): Promise<void> {
        return await RequestManager.share.delete('/users', this.#query)
    }
}
    

class UserListRequest<T extends Partial<User>> extends Promise<T[]> {

    #query?: UserListQuery

    constructor(query?: UserListQuery) {
        super(() => {})
        this.#query = query
    }

    order(order: UserSortOrder | UserSortOrder[]): UserListRequest<T> {
        this.#query = {...this.#query, _order: order}
        return this
    }

    skip(skip: number): UserListRequest<T> {
        this.#query = {...this.#query, _skip: skip}
        return this
    }

    limt(limit: number): UserListRequest<T> {
        this.#query = {...this.#query, _limit:limit}
        return this
    }

    pageSize(pageSize: number): UserListRequest<T> {
        this.#query = {...this.#query, _pageSize: pageSize}
        return this
    }

    pageNo(pageNo: number): UserListRequest<T> {
        this.#query = {...this.#query, _pageNo: pageNo}
        return this
    }

    pick(picks: UserResultPick[]): UserListRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserListRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserListRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<User[]> {
        return await RequestManager.share.get('/users',this.#query)
    }
}

class UserSignInRequest<T extends Partial<UserSession>> extends Promise<T> {

    #input: UserSessionInput
    #query?: UserSingleQuery

    constructor(input: UserSessionInput, query?:UserSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: UserResultPick[]): UserSignInRequest<T> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: UserResultPick[]): UserSignInRequest<T> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: UserInclude[]): UserSignInRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<UserSession> {
        const session = await RequestManager.share.post('/users/session', this.#input, this.#query) as UserSession
        SessionManager.share.setSession(session)
        return session
    }
}

class UserClient {

    create(input: UserCreateInput, query?: UserSingleQuery): UserCreateRequest<User> {
        return new UserCreateRequest(input, query)
    }

    createMany(input: UserCreateInput[]): UserCreateManyRequest<User> {
        return new UserCreateManyRequest(input)
    }

    id(id: string, query?: UserSingleQuery) {
        return new UserIDRequest(id, query)
    }

    update(id: string, input: UserUpdateInput, query?: UserSingleQuery): UserUpdateRequest<User> {
        return new UserUpdateRequest(id, input, query)
    }

    upsert(input: UserQueryData): UserUpsertRequest<User> {
        return new UserUpsertRequest(input)
    }

    updateMany(input: UserQueryData): UserUpdateManyRequest<User> {
        return new UserUpdateManyRequest(input)
    }

    find(query?: UserListQuery): UserListRequest<User> {
        return new UserListRequest(query)
    }

    delete(id: string): UserDeleteRequest {
        return new UserDeleteRequest(id)
    }

    deleteMany(query?: UserSeekQuery): UserDeleteManyRequest {
        return new UserDeleteManyRequest(query)
    }

    signIn(input: UserSessionInput, query?: UserSingleQuery): UserSignInRequest<UserSession>{
       return new UserSignInRequest(input, query)
    }

}


class ArticleCreateRequest<T extends Partial<Article>> extends Promise<T> {

    #input: ArticleCreateInput
    #query?: ArticleSingleQuery

    constructor(input: ArticleCreateInput, query?:ArticleSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: ArticleResultPick[]): ArticleCreateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleCreateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleCreateRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<T> {
        return await RequestManager.share.post('/articles', this.#input, this.#query)
    }
}

class ArticleUpdateRequest<T extends Partial<Article>> extends Promise<T> {

    #id: string
    #input: ArticleUpdateInput
    #query?: ArticleSingleQuery

    constructor(id:string, input: ArticleUpdateInput, query?: ArticleSingleQuery,) {
        super(() => {})
        this.#id = id
        this.#input = input
        this.#query = query
    }

    pick(picks: ArticleResultPick[]): ArticleUpdateRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleUpdateRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleUpdateRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<Article> {
        return await RequestManager.share.patch(`/articles/${this.#id}`, this.#input, this.#query)
    }
}

class ArticleDeleteRequest extends Promise<void> {

    #id: string

    constructor(id: string) {
        super(() => {})
        this.#id = id
    }
    async exec(): Promise<void> {
        return await RequestManager.share.delete(`/articles/${this.#id}`)
    }
}

class ArticleIDRequest<T extends Partial<Article>> extends Promise<T> {

    #id: string
    #query?: ArticleSingleQuery

    constructor(id: string, query?: ArticleSingleQuery) {
        super(() => {})
        this.#id = id,
        this.#query = query
    }

    pick(picks: ArticleResultPick[]): ArticleIDRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleIDRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleIDRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<Article> {
        return await RequestManager.share.get(`/articles/${this.#id}`, this.#query)
    }
}

class ArticleUpsertRequest<T extends Partial<Article>> extends Promise<T> {

    #input: ArticleQueryData

    constructor(input: ArticleQueryData){
        super(() => {})
        this.#input = input
    }

    async exec(): Promise<T> {
        return await RequestManager.share.post('/articles', { '_upsert': this.#input })
    }
}
    

class ArticleCreateManyRequest<T extends Partial<Article>> extends Promise<T> {

    #input: ArticleCreateInput[]
    #query?: ArticleSingleQuery

     constructor(input: ArticleCreateInput[], query?:ArticleSingleQuery){
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: ArticleResultPick[]): ArticleCreateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleCreateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleCreateManyRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<T[]> {
        return await RequestManager.share.post('/articles', { '_create': this.#input })
    }
}
    

class ArticleUpdateManyRequest<T extends Partial<Article>> extends Promise<T> {

    #input: ArticleQueryData
    #query?: ArticleSingleQuery

    constructor(input: ArticleQueryData, query?:ArticleSingleQuery) {
        super(() => {})
        this.#input = input
        this.#query = query
    }

    pick(picks: ArticleResultPick[]): ArticleUpdateManyRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleUpdateManyRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleUpdateManyRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<Article> {
        return await RequestManager.share.patch('/articles', { '_update': this.#input })
    }
}
    

class ArticleDeleteManyRequest extends Promise<void> {

    #query?: ArticleSeekQuery

    constructor(query?: ArticleSeekQuery) {
        super(() => {})
        this.#query = query
    }

    async exec(): Promise<void> {
        return await RequestManager.share.delete('/articles', this.#query)
    }
}
    

class ArticleListRequest<T extends Partial<Article>> extends Promise<T[]> {

    #query?: ArticleListQuery

    constructor(query?: ArticleListQuery) {
        super(() => {})
        this.#query = query
    }

    order(order: ArticleSortOrder | ArticleSortOrder[]): ArticleListRequest<T> {
        this.#query = {...this.#query, _order: order}
        return this
    }

    skip(skip: number): ArticleListRequest<T> {
        this.#query = {...this.#query, _skip: skip}
        return this
    }

    limt(limit: number): ArticleListRequest<T> {
        this.#query = {...this.#query, _limit:limit}
        return this
    }

    pageSize(pageSize: number): ArticleListRequest<T> {
        this.#query = {...this.#query, _pageSize: pageSize}
        return this
    }

    pageNo(pageNo: number): ArticleListRequest<T> {
        this.#query = {...this.#query, _pageNo: pageNo}
        return this
    }

    pick(picks: ArticleResultPick[]): ArticleListRequest<Pick<T, typeof picks[number]>> {
        this.#query = {...this.#query, _pick: picks}
        return this
    }

    omit(omits: ArticleResultPick[]): ArticleListRequest<Omit<T, typeof omits[number]>> {
        this.#query = {...this.#query, _omit: omits}
        return this
    }

    include(includes: ArticleInclude[]): ArticleListRequest<T> {
        this.#query = {...this.#query, _includes: includes }
        return this
    }

    async exec(): Promise<Article[]> {
        return await RequestManager.share.get('/articles',this.#query)
    }
}

class ArticleClient {

    create(input: ArticleCreateInput, query?: ArticleSingleQuery): ArticleCreateRequest<Article> {
        return new ArticleCreateRequest(input, query)
    }

    createMany(input: ArticleCreateInput[]): ArticleCreateManyRequest<Article> {
        return new ArticleCreateManyRequest(input)
    }

    id(id: string, query?: ArticleSingleQuery) {
        return new ArticleIDRequest(id, query)
    }

    update(id: string, input: ArticleUpdateInput, query?: ArticleSingleQuery): ArticleUpdateRequest<Article> {
        return new ArticleUpdateRequest(id, input, query)
    }

    upsert(input: ArticleQueryData): ArticleUpsertRequest<Article> {
        return new ArticleUpsertRequest(input)
    }

    updateMany(input: ArticleQueryData): ArticleUpdateManyRequest<Article> {
        return new ArticleUpdateManyRequest(input)
    }

    find(query?: ArticleListQuery): ArticleListRequest<Article> {
        return new ArticleListRequest(query)
    }

    delete(id: string): ArticleDeleteRequest {
        return new ArticleDeleteRequest(id)
    }

    deleteMany(query?: ArticleSeekQuery): ArticleDeleteManyRequest {
        return new ArticleDeleteManyRequest(query)
    }

}


class API {

    get users(): UserClient {
        return new UserClient()
    }

    get articles(): ArticleClient {
        return new ArticleClient()
    }

    get session(): SessionManager {
       return SessionManager.share
    }

    signOut(): void {
       SessionManager.share.clearSession()
    }

}


export const api = new API()


