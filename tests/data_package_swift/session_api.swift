import Foundation
import QSParser

public enum StringQuery: Codable {
    case eq(_ value: String)
    case neq(_ value: String)
    case null(_ value: Bool)
    case gt(_ value: String)
    case gte(_ value: String)
    case lt(_ value: String)
    case lte(_ value: String)
    case contains(_ value: String, mode: Mode = .default)
    case prefix(_ value: String, mode: Mode = .default)
    case suffix(_ value: String, mode: Mode = .default)
    case match(_ value: String, mode: Mode = .default)
    case or(_ values: [StringQuery])
    case and(_ values: [StringQuery])

    public enum Mode: String, Codable {
        case `default` = "default"
        case caseInsensitive = "insensitive"
    }

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
        case gt = "_gt"
        case gte = "_gte"
        case lt = "_lt"
        case lte = "_lte"
        case contains = "_contains"
        case prefix = "_prefix"
        case suffix = "_suffix"
        case match = "_match"
        case mode = "_mode"
        case or = "_or"
        case and = "_and"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(String.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(String.self, forKey: .neq))
        }else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        }  else if container.contains(.gt) {
            self = .gt(try! container.decode(String.self, forKey: .gt))
        } else if container.contains(.gte) {
            self = .gte(try! container.decode(String.self, forKey: .gte))
        } else if container.contains(.lt) {
            self = .lt(try! container.decode(String.self, forKey: .lt))
        } else if container.contains(.lte) {
            self = .lte(try! container.decode(String.self, forKey: .lte))
        } else if container.contains(.contains) {
            self = .contains(
                try! container.decode(String.self, forKey: .contains),
                mode: (try? container.decode(Mode.self, forKey: .mode)) ?? .default
            )
        } else if container.contains(.prefix) {
            self = .prefix(
                try! container.decode(String.self, forKey: .prefix),
                mode: (try? container.decode(Mode.self, forKey: .mode)) ?? .default
            )
        } else if container.contains(.suffix) {
            self = .suffix(
                try! container.decode(String.self, forKey: .suffix),
                mode: (try? container.decode(Mode.self, forKey: .mode)) ?? .default
            )
        } else if container.contains(.match) {
            self = .match(
                try! container.decode(String.self, forKey: .match),
                mode: (try? container.decode(Mode.self, forKey: .mode)) ?? .default
            )
        } else if container.contains(.or) {
            self = .or(try! container.decode([StringQuery].self, forKey: .or))
        } else if container.contains(.and) {
            self = .and(try! container.decode([StringQuery].self, forKey: .and))
        } else {
            self = .eq("")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .eq(let value):
            try! container.encode(value, forKey: .eq)
        case .neq(let value):
            try! container.encode(value, forKey: .neq)
        case .null(let value):
            try! container.encode(value, forKey: .null)
        case .gt(let value):
            try! container.encode(value, forKey: .gt)
        case .gte(let value):
            try! container.encode(value, forKey: .gte)
        case .lt(let value):
            try! container.encode(value, forKey: .lt)
        case .lte(let value):
            try! container.encode(value, forKey: .lte)
        case .contains(let value, let mode):
            try! container.encode(value, forKey: .contains)
            if mode != .default {
                try! container.encode(mode, forKey: .mode)
            }
        case .prefix(let value, let mode):
            try! container.encode(value, forKey: .prefix)
            if mode != .default {
                try! container.encode(mode, forKey: .mode)
            }
        case .suffix(let value, let mode):
            try! container.encode(value, forKey: .suffix)
            if mode != .default {
                try! container.encode(mode, forKey: .mode)
            }
        case .match(let value, let mode):
            try! container.encode(value, forKey: .match)
            if mode != .default {
                try! container.encode(mode, forKey: .mode)
            }
        case .or(let value):
            try! container.encode(value, forKey: .or)
        case .and(let value):
            try! container.encode(value, forKey: .and)
        }
    }
}

public enum IntQuery: Codable {
    case eq(_ value: Int)
    case neq(_ value: Int)
    case null(_ value: Bool)
    case gt(_ value: Int)
    case gte(_ value: Int)
    case lt(_ value: Int)
    case lte(_ value: Int)
    case or(_ values: [IntQuery])
    case and(_ values: [IntQuery])

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
        case gt = "_gt"
        case gte = "_gte"
        case lt = "_lt"
        case lte = "_lte"
        case or = "_or"
        case and = "_and"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(Int.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(Int.self, forKey: .neq))
        } else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        } else if container.contains(.gt) {
            self = .gt(try! container.decode(Int.self, forKey: .gt))
        } else if container.contains(.gte) {
            self = .gte(try! container.decode(Int.self, forKey: .gte))
        } else if container.contains(.lt) {
            self = .lt(try! container.decode(Int.self, forKey: .lt))
        } else if container.contains(.lte) {
            self = .lte(try! container.decode(Int.self, forKey: .lte))
        } else if container.contains(.or) {
            self = .or(try! container.decode([IntQuery].self, forKey: .or))
        } else if container.contains(.and) {
            self = .and(try! container.decode([IntQuery].self, forKey: .and))
        } else {
            self = .eq(0)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .eq(let value):
            try! container.encode(value, forKey: .eq)
        case .neq(let value):
            try! container.encode(value, forKey: .neq)
        case .null(let value):
            try! container.encode(value, forKey: .null)
        case .gt(let value):
            try! container.encode(value, forKey: .gt)
        case .gte(let value):
            try! container.encode(value, forKey: .gte)
        case .lt(let value):
            try! container.encode(value, forKey: .lt)
        case .lte(let value):
            try! container.encode(value, forKey: .lte)
        case .or(let value):
            try! container.encode(value, forKey: .or)
        case .and(let value):
            try! container.encode(value, forKey: .and)
        }
    }
}

public enum FloatQuery: Codable {
    case eq(_ value: Float)
    case neq(_ value: Float)
    case null(_ value: Bool)
    case gt(_ value: Float)
    case gte(_ value: Float)
    case lt(_ value: Float)
    case lte(_ value: Float)
    case or(_ values: [FloatQuery])
    case and(_ values: [FloatQuery])

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
        case gt = "_gt"
        case gte = "_gte"
        case lt = "_lt"
        case lte = "_lte"
        case or = "_or"
        case and = "_and"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(Float.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(Float.self, forKey: .neq))
        } else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        } else if container.contains(.gt) {
            self = .gt(try! container.decode(Float.self, forKey: .gt))
        } else if container.contains(.gte) {
            self = .gte(try! container.decode(Float.self, forKey: .gte))
        } else if container.contains(.lt) {
            self = .lt(try! container.decode(Float.self, forKey: .lt))
        } else if container.contains(.lte) {
            self = .lte(try! container.decode(Float.self, forKey: .lte))
        } else if container.contains(.or) {
            self = .or(try! container.decode([FloatQuery].self, forKey: .or))
        } else if container.contains(.and) {
            self = .and(try! container.decode([FloatQuery].self, forKey: .and))
        } else {
            self = .eq(0)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .eq(let value):
            try! container.encode(value, forKey: .eq)
        case .neq(let value):
            try! container.encode(value, forKey: .neq)
        case .null(let value):
            try! container.encode(value, forKey: .null)
        case .gt(let value):
            try! container.encode(value, forKey: .gt)
        case .gte(let value):
            try! container.encode(value, forKey: .gte)
        case .lt(let value):
            try! container.encode(value, forKey: .lt)
        case .lte(let value):
            try! container.encode(value, forKey: .lte)
        case .or(let value):
            try! container.encode(value, forKey: .or)
        case .and(let value):
            try! container.encode(value, forKey: .and)
        }
    }
}

public enum BoolQuery: Codable {
    case eq(_ value: Bool)
    case neq(_ value: Bool)
    case null(_ value: Bool)
    case or(_ values: [BoolQuery])
    case and(_ values: [BoolQuery])

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
        case or = "_or"
        case and = "_and"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(Bool.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(Bool.self, forKey: .neq))
        } else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        } else if container.contains(.or) {
            self = .or(try! container.decode([BoolQuery].self, forKey: .or))
        } else if container.contains(.and) {
            self = .and(try! container.decode([BoolQuery].self, forKey: .and))
        } else {
            self = .eq(true)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .eq(let value):
            try! container.encode(value, forKey: .eq)
        case .neq(let value):
            try! container.encode(value, forKey: .neq)
        case .null(let value):
            try! container.encode(value, forKey: .null)
        case .or(let value):
            try! container.encode(value, forKey: .or)
        case .and(let value):
            try! container.encode(value, forKey: .and)
        }
    }
}

public enum DateQuery: Codable {
    case eq(_ value: Date)
    case neq(_ value: Date)
    case null(_ value: Bool)
    case gt(_ value: Date)
    case gte(_ value: Date)
    case lt(_ value: Date)
    case lte(_ value: Date)
    case after(_ value: Date)
    case before(_ value: Date)
    case or(_ values: [DateQuery])
    case and(_ values: [DateQuery])

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
        case gt = "_gt"
        case gte = "_gte"
        case lt = "_lt"
        case lte = "_lte"
        case after = "_after"
        case before = "_before"
        case or = "_or"
        case and = "_and"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(Date.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(Date.self, forKey: .neq))
        } else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        } else if container.contains(.gt) {
            self = .gt(try! container.decode(Date.self, forKey: .gt))
        } else if container.contains(.gte) {
            self = .gte(try! container.decode(Date.self, forKey: .gte))
        } else if container.contains(.lt) {
            self = .lt(try! container.decode(Date.self, forKey: .lt))
        } else if container.contains(.lte) {
            self = .lte(try! container.decode(Date.self, forKey: .lte))
        } else if container.contains(.after) {
            self = .after(try! container.decode(Date.self, forKey: .after))
        } else if container.contains(.before) {
            self = .before(try! container.decode(Date.self, forKey: .before))
        } else if container.contains(.or) {
            self = .or(try! container.decode([DateQuery].self, forKey: .or))
        } else if container.contains(.and) {
            self = .and(try! container.decode([DateQuery].self, forKey: .and))
        } else {
            self = .eq(Date())
        }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .eq(let value):
                try! container.encode(value, forKey: .eq)
            case .neq(let value):
                try! container.encode(value, forKey: .neq)
            case .null(let value):
                try! container.encode(value, forKey: .null)
            case .gt(let value):
                try! container.encode(value, forKey: .gt)
            case .gte(let value):
                try! container.encode(value, forKey: .gte)
            case .lt(let value):
                try! container.encode(value, forKey: .lt)
            case .lte(let value):
                try! container.encode(value, forKey: .lte)
            case .after(let value):
                try! container.encode(value, forKey: .after)
            case .before(let value):
                try! container.encode(value, forKey: .before)
            case .or(let value):
                try! container.encode(value, forKey: .or)
            case .and(let value):
                try! container.encode(value, forKey: .and)
            }
        }
}

public enum IDQuery: Codable {
    case eq(_ value: String)
    case neq(_ value: String)
    case null(_ value: Bool)

    public enum CodingKeys: String, CodingKey {
        case eq = "_eq"
        case neq = "_neq"
        case null = "_null"
    }

    public init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.eq) {
            self = .eq(try! container.decode(String.self, forKey: .eq))
        } else if container.contains(.neq) {
            self = .neq(try! container.decode(String.self, forKey: .neq))
        } else if container.contains(.null) {
            self = .null(try! container.decode(Bool.self, forKey: .null))
        } else {
            throw NSError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .eq(let value):
            try! container.encode(value, forKey: .eq)
        case .neq(let value):
            try! container.encode(value, forKey: .neq)
        case .null(let value):
            try! container.encode(value, forKey: .null)
        }
    }
}

public enum SortOrder: Int, Codable {
    case asc = 1
    case desc = -1
}

public class Link: Codable {
    public var _add: String
    public init(link: String) {
        self._add = link
    }
}

public class UnLink: Codable {
    public var _del: String
    public init(unLink: String) {
        self._del = unLink
    }
}

public enum CreateOrLink<T: Codable>: Codable{
    case createInput(T)
    case link(Link)
}

public enum UpdateOrLink<T: Codable>: Codable{
    case updateInput(T)
    case link(Link)
    case unLink(UnLink)
}

public class UserCreateInput: Codable {
    public var username: String
    public var password: String
    public var phoneNum: String?

    public init(
        username: String,
        password: String,
        phoneNum: String? = nil
    ) {
        self.username = username
        self.password = password
        self.phoneNum = phoneNum
    }
}

public class UserUpdateInput: Codable {
    public var username: String?
    public var password: String?
    public var phoneNum: String?

    public init(
        username: String? = nil,
        password: String? = nil,
        phoneNum: String? = nil
    ) {
        self.username = username
        self.password = password
        self.phoneNum = phoneNum
    }
}

public enum UserSortOrder: String, Codable {
    case username = "username"
    case usernameDesc = "-username"
    case phoneNum = "phoneNum"
    case phoneNumDesc = "-phoneNum"
}

public prefix func -(rhs: UserSortOrder) -> UserSortOrder {
    if rhs.rawValue.starts(with: "-") {
        return UserSortOrder(rawValue: String(rhs.rawValue.dropFirst()))!
    } else {
        return UserSortOrder(rawValue: "-" + rhs.rawValue)!
    }
}

public enum UserResultPick: String, Codable {
    case id = "id"
    case username = "username"
    case phoneNum = "phoneNum"
}

public enum UserManyRequestType: Codable {
    case update
    case create
    case upsert

    func getContent(input: UserQueryData) -> Dictionary<String, UserQueryData> {
        if self  == .update {
            return ["_update": input]
        }
        else if self == .upsert {
            return ["_upsert": input]
        }
        return [String: UserQueryData]()
    }

    func getContent(input: [UserCreateInput]) -> Dictionary<String, [UserCreateInput]> {
        if self  == .create {
            return ["_create": input]
        }
        return [String: [UserCreateInput]]()
    }
}

public class UserSingleQuery: Codable {
    fileprivate var _pick: [UserResultPick]? = nil
    fileprivate var _omit: [UserResultPick]? = nil

    public static func pick(_ picks: [UserResultPick]) -> UserSingleQuery {
        let instance = UserSingleQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [UserResultPick]) -> UserSingleQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [UserResultPick]) -> UserSingleQuery {
        let instance = UserSingleQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [UserResultPick]) -> UserSingleQuery {
        _omit = omits
        return self
    }
}

public class UserSeekQuery: Codable {
    public var id: StringQuery? = nil
    public var username: StringQuery? = nil
    public var phoneNum: StringQuery? = nil

    public static func `where`(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) -> UserSeekQuery {
        let instance = UserSeekQuery()
        instance.id = id
        instance.username = username
        instance.phoneNum = phoneNum
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) -> UserSeekQuery {
        if id != nil { self.id = id }
        if username != nil { self.username = username }
        if phoneNum != nil { self.phoneNum = phoneNum }
        return self
    }
}

public class UserQueryData: Codable {
    fileprivate var _query: UserSeekQuery
    fileprivate var _data: UserUpdateInput

    public init(
        _query: UserSeekQuery,
        _data: UserUpdateInput
    ) {
        self._query = _query
        self._data = _data
    }
}

public class UserListQuery: Codable {
    public var id: StringQuery? = nil
    public var username: StringQuery? = nil
    public var phoneNum: StringQuery? = nil
    fileprivate var _order: [UserSortOrder]? = nil
    fileprivate var _limit: Int? = nil
    fileprivate var _skip: Int? = nil
    fileprivate var _pageNo: Int? = nil
    fileprivate var _pageSize: Int? = nil
    fileprivate var _pick: [UserResultPick]? = nil
    fileprivate var _omit: [UserResultPick]? = nil

    public static func `where`(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) -> UserListQuery {
        let instance = UserListQuery()
        instance.id = id
        instance.username = username
        instance.phoneNum = phoneNum
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) -> UserListQuery {
        if id != nil { self.id = id }
        if username != nil { self.username = username }
        if phoneNum != nil { self.phoneNum = phoneNum }
        return self
    }

    public static func order(_ order: UserSortOrder) -> UserListQuery {
        let instance = UserListQuery()
        instance._order = [order]
        return instance
    }

    public static func order(_ orders: [UserSortOrder]) -> UserListQuery {
        let instance = UserListQuery()
        instance._order = orders
        return instance
    }

    public func order(_ order: UserSortOrder) -> UserListQuery {
        if _order == nil { _order = [] }
        _order!.append(order)
        return self
    }

    public func order(_ orders: [UserSortOrder]) -> UserListQuery {
        if _order == nil { _order = [] }
        _order!.append(contentsOf: orders)
        return self
    }

    public static func limit(_ limit: Int) -> UserListQuery {
        let instance = UserListQuery()
        instance._limit = limit
        return instance
    }

    public func limit(_ limit: Int) -> UserListQuery {
        _limit = limit
        return self
    }
    public static func skip(_ skip: Int) -> UserListQuery {
        let instance = UserListQuery()
        instance._skip = skip
        return instance
    }

    public func skip(_ skip: Int) -> UserListQuery {
        _skip = skip
        return self
    }
    public static func pageNo(_ pageNo: Int) -> UserListQuery {
        let instance = UserListQuery()
        instance._pageNo = pageNo
        return instance
    }

    public func pageNo(_ pageNo: Int) -> UserListQuery {
        _pageNo = pageNo
        return self
    }
    public static func pageSize(_ pageSize: Int) -> UserListQuery {
        let instance = UserListQuery()
        instance._pageSize = pageSize
        return instance
    }

    public func pageSize(_ pageSize: Int) -> UserListQuery {
        _pageSize = pageSize
        return self
    }

    public static func pick(_ picks: [UserResultPick]) -> UserListQuery {
        let instance = UserListQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [UserResultPick]) -> UserListQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [UserResultPick]) -> UserListQuery {
        let instance = UserListQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [UserResultPick]) -> UserListQuery {
        _omit = omits
        return self
    }
}

public class User: Codable {
    public let id: String!
    public let username: String!
    public let phoneNum: String!

    public init(
        id: String,
        username: String,
        phoneNum: String? = nil
    ) {
        self.id = id
        self.username = username
        self.phoneNum = phoneNum
    }
}

public class ArticleCreateInput: Codable {
    public var title: String
    public var content: String?

    public init(
        title: String,
        content: String? = nil
    ) {
        self.title = title
        self.content = content
    }
}

public class ArticleUpdateInput: Codable {
    public var title: String?
    public var content: String?

    public init(
        title: String? = nil,
        content: String? = nil
    ) {
        self.title = title
        self.content = content
    }
}

public enum ArticleSortOrder: String, Codable {
    case title = "title"
    case titleDesc = "-title"
    case content = "content"
    case contentDesc = "-content"
}

public prefix func -(rhs: ArticleSortOrder) -> ArticleSortOrder {
    if rhs.rawValue.starts(with: "-") {
        return ArticleSortOrder(rawValue: String(rhs.rawValue.dropFirst()))!
    } else {
        return ArticleSortOrder(rawValue: "-" + rhs.rawValue)!
    }
}

public enum ArticleResultPick: String, Codable {
    case id = "id"
    case title = "title"
    case content = "content"
}

public enum ArticleManyRequestType: Codable {
    case update
    case create
    case upsert

    func getContent(input: ArticleQueryData) -> Dictionary<String, ArticleQueryData> {
        if self  == .update {
            return ["_update": input]
        }
        else if self == .upsert {
            return ["_upsert": input]
        }
        return [String: ArticleQueryData]()
    }

    func getContent(input: [ArticleCreateInput]) -> Dictionary<String, [ArticleCreateInput]> {
        if self  == .create {
            return ["_create": input]
        }
        return [String: [ArticleCreateInput]]()
    }
}

public class ArticleSingleQuery: Codable {
    fileprivate var _pick: [ArticleResultPick]? = nil
    fileprivate var _omit: [ArticleResultPick]? = nil

    public static func pick(_ picks: [ArticleResultPick]) -> ArticleSingleQuery {
        let instance = ArticleSingleQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [ArticleResultPick]) -> ArticleSingleQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [ArticleResultPick]) -> ArticleSingleQuery {
        let instance = ArticleSingleQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [ArticleResultPick]) -> ArticleSingleQuery {
        _omit = omits
        return self
    }
}

public class ArticleSeekQuery: Codable {
    public var id: StringQuery? = nil
    public var title: StringQuery? = nil
    public var content: StringQuery? = nil

    public static func `where`(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) -> ArticleSeekQuery {
        let instance = ArticleSeekQuery()
        instance.id = id
        instance.title = title
        instance.content = content
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) -> ArticleSeekQuery {
        if id != nil { self.id = id }
        if title != nil { self.title = title }
        if content != nil { self.content = content }
        return self
    }
}

public class ArticleQueryData: Codable {
    fileprivate var _query: ArticleSeekQuery
    fileprivate var _data: ArticleUpdateInput

    public init(
        _query: ArticleSeekQuery,
        _data: ArticleUpdateInput
    ) {
        self._query = _query
        self._data = _data
    }
}

public class ArticleListQuery: Codable {
    public var id: StringQuery? = nil
    public var title: StringQuery? = nil
    public var content: StringQuery? = nil
    fileprivate var _order: [ArticleSortOrder]? = nil
    fileprivate var _limit: Int? = nil
    fileprivate var _skip: Int? = nil
    fileprivate var _pageNo: Int? = nil
    fileprivate var _pageSize: Int? = nil
    fileprivate var _pick: [ArticleResultPick]? = nil
    fileprivate var _omit: [ArticleResultPick]? = nil

    public static func `where`(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance.id = id
        instance.title = title
        instance.content = content
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) -> ArticleListQuery {
        if id != nil { self.id = id }
        if title != nil { self.title = title }
        if content != nil { self.content = content }
        return self
    }

    public static func order(_ order: ArticleSortOrder) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._order = [order]
        return instance
    }

    public static func order(_ orders: [ArticleSortOrder]) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._order = orders
        return instance
    }

    public func order(_ order: ArticleSortOrder) -> ArticleListQuery {
        if _order == nil { _order = [] }
        _order!.append(order)
        return self
    }

    public func order(_ orders: [ArticleSortOrder]) -> ArticleListQuery {
        if _order == nil { _order = [] }
        _order!.append(contentsOf: orders)
        return self
    }

    public static func limit(_ limit: Int) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._limit = limit
        return instance
    }

    public func limit(_ limit: Int) -> ArticleListQuery {
        _limit = limit
        return self
    }
    public static func skip(_ skip: Int) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._skip = skip
        return instance
    }

    public func skip(_ skip: Int) -> ArticleListQuery {
        _skip = skip
        return self
    }
    public static func pageNo(_ pageNo: Int) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._pageNo = pageNo
        return instance
    }

    public func pageNo(_ pageNo: Int) -> ArticleListQuery {
        _pageNo = pageNo
        return self
    }
    public static func pageSize(_ pageSize: Int) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._pageSize = pageSize
        return instance
    }

    public func pageSize(_ pageSize: Int) -> ArticleListQuery {
        _pageSize = pageSize
        return self
    }

    public static func pick(_ picks: [ArticleResultPick]) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [ArticleResultPick]) -> ArticleListQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [ArticleResultPick]) -> ArticleListQuery {
        let instance = ArticleListQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [ArticleResultPick]) -> ArticleListQuery {
        _omit = omits
        return self
    }
}

public class Article: Codable {
    public let id: String!
    public let title: String!
    public let content: String!

    public init(
        id: String,
        title: String,
        content: String? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
    }
}

public struct UserSessionInput: Codable {
    public let username: String
    public let password: String
}

public struct Session: Codable {
    public let token: String
    public let user: User
}

public struct Response<T: Codable>: Codable {
    let data: T
}

@propertyWrapper
public struct UserDefault<T: Codable> {

    private var key: String

    public var wrappedValue: T? {
        didSet {
            if let wrappedValue = wrappedValue {
                let data = try! JSONEncoder().encode(wrappedValue)
                let string = String(data: data, encoding: .utf8)
                UserDefaults.standard.setValue(string, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    fileprivate init(key: String) {
        self.key = key
        if let string = UserDefaults.standard.value(forKey: key) as? String {
            let data = string.data(using: .utf8)!
            self.wrappedValue = try! JSONDecoder().decode(T.self, from: data)
        } else {
            self.wrappedValue = nil
        }
    }
}

public struct SessionManager {

    public static var shared = SessionManager()

    @UserDefault(key: "session") public fileprivate(set) var session: Session?

    private init() { }
}

public func signOut() {
    SessionManager.shared.session = nil
}

struct RequestManager {

    static let shared = RequestManager()

    let baseURL: String = "None"

    func qs<T: Codable>(_ query: T? = nil) -> String {
        if let query = query {
            return "?" + (try! QSEncoder().encode(query))
        } else {
            return ""
        }
    }

    func url<T: Codable>(url: String, query: T) -> URL {
        return URL(string: baseURL + url + qs(query))!
    }

    func request(method: String, url: String) async throws {
        let _: Int? = try await request(method: method, url: url, input: nil as Int?, query: nil as Int?)
    }

    func request<U: Codable>(
        method: String,
        url: String,
        query: U? = nil
    ) async throws {
        let _: Int? = try await request(method: method, url: url, input: nil as Int?, query: query)
    }

    func request<U: Codable, V: Codable>(
        method: String,
        url: String,
        query: U? = nil
    ) async throws -> V? {
        return try await request(method: method, url: url, input: nil as Int?, query: query)
    }

    func request<T: Codable, U: Codable, V: Codable>(
        method: String,
        url: String,
        input: T? = nil,
        query: U? = nil
    ) async throws -> V? {
        let url = self.url(url: url, query: query)
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let input = input {
            request.httpBody = try! JSONEncoder().encode(input)
        }
        if let session = SessionManager.shared.session {
            request.setValue("Bearer \(session.token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let responseObject = try! JSONDecoder().decode(Response<V>.self, from: data)
                return responseObject.data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func post<T: Codable, U: Codable, V: Codable>(
        url: String,
        input: T,
        query: U? = nil
    ) async throws -> V {
        return try await request(method: "POST", url: url, input: input, query: query)!
    }

    func patch<T: Codable, U: Codable, V: Codable>(
        url: String,
        input: T,
        query: U? = nil
    ) async throws -> V {
        return try await request(method: "PATCH", url: url, input: input, query: query)!
    }

    func delete(url: String) async throws {
        try await request(method: "DELETE", url: url)
    }

    func delete<U: Codable>(url: String, query: U? = nil) async throws {
        try await request(method: "DELETE", url: url, query: query)
    }

    func get<U: Codable, V: Codable>(
        url: String,
        query: U? = nil
    ) async throws -> V? {
        return try await request(method: "GET", url: url, query: query)!
    }
}

public class UserCreateRequest {
    internal var input: UserCreateInput
    internal var query: UserSingleQuery?

    internal init(input: UserCreateInput, query: UserSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> User {
        return try await RequestManager.shared.post(
            url: "/users", input: input, query: query
        )
    }

    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> User {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> User {
        return try await self.omit(omits).exec()
    }
}

public class UserUpdateRequest {
    internal var id: String
    internal var input: UserUpdateInput
    internal var query: UserSingleQuery?

    internal init(id: String, input: UserUpdateInput, query: UserSingleQuery? = nil) {
        self.id = id
        self.input = input
        self.query = query    }

    internal func exec() async throws -> User {
        return try await RequestManager.shared.patch(
            url: "/users/\(id)", input: input, query: query
        )
    }

    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> User {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> User {
        return try await self.omit(omits).exec()
    }
}

public class UserDeleteRequest {
    internal var id: String

    internal init(id: String) {
        self.id = id
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/users/\(id)"
        )
    }
}

public class UserIDRequest {
    internal var id: String
    internal var query: UserSingleQuery?

    internal init(id: String, query: UserSingleQuery? = nil) {
        self.id = id
        self.query = query
    }

    internal func exec() async throws -> User {
        return try await RequestManager.shared.get(
            url: "/users/\(id)", query: query
        )!
    }

    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> User {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> User {
        return try await self.omit(omits).exec()
    }
}

public class UserUpsertRequest {
    internal var input: UserQueryData
    internal var query: UserSeekQuery?

    internal init(input: UserQueryData, query: UserSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> User {
        return try await RequestManager.shared.post(
            url: "/users",
            input: UserManyRequestType.upsert.getContent(input: self.input),
            query: self.query
        )
    }
}

public class UserCreateManyRequest {
    internal var input: [UserCreateInput]
    internal var query: UserSingleQuery?

    internal init(input: [UserCreateInput], query: UserSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> [User] {
        return try await RequestManager.shared.post(
            url: "/users", input: UserManyRequestType.create.getContent(input: self.input), query: query
        )
    }

    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> [User] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> [User] {
        return try await self.omit(omits).exec()
    }
}

public class UserUpdateManyRequest {
    internal var input: UserQueryData
    internal var query: UserSeekQuery?

    internal init(input: UserQueryData, query: UserSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> [User] {
        return try await RequestManager.shared.patch(
            url: "/users", input: UserManyRequestType.update.getContent(input: self.input), query: self.query
        )
    }
}

public class UserDeleteManyRequest {
    internal var query: UserSeekQuery?

    internal init(query: UserSeekQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/users",
            query: self.query
        )
    }
}

public class UserListRequest {
    internal var query: UserListQuery?

    internal init(query: UserListQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws -> [User] {
        return try await RequestManager.shared.get(
            url: "/users", query: query
        )!
    }

    public func order(_ order: UserSortOrder) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.order(order)
        return self
    }

    public func order(_ orders: [UserSortOrder]) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.order(orders)
        return self
    }

    public func order(_ order: UserSortOrder) async throws -> [User] {
        return try await self.order(order).exec()
    }

    public func order(_ orders: [UserSortOrder]) async throws -> [User] {
        return try await self.order(orders).exec()
    }

    public func skip(_ skip: Int) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.skip(skip)
        return self
    }

    public func skip(_ skip: Int) async throws -> [User] {
        return try await self.skip(skip).exec()
    }

    public func limit(_ limit: Int) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.limit(limit)
        return self
    }

    public func limit(_ limit: Int) async throws -> [User] {
        return try await self.limit(limit).exec()
    }

    public func pageSize(_ pageSize: Int) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.pageSize(pageSize)
        return self
    }

    public func pageSize(_ pageSize: Int) async throws -> [User] {
        return try await self.pageSize(pageSize).exec()
    }

    public func pageNo(_ pageNo: Int) -> UserListRequest {
        if query == nil { query = UserListQuery() }
        query = query!.pageNo(pageNo)
        return self
    }

    public func pageNo(_ pageNo: Int) async throws -> [User] {
        return try await self.pageNo(pageNo).exec()
    }
    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserListQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> [User] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserListQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> [User] {
        return try await self.omit(omits).exec()
    }
}

public class UserSignInRequest {
    internal var input: UserSessionInput
    internal var query: UserSingleQuery?

    internal init(input: UserSessionInput, query: UserSingleQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> Session {
        SessionManager.shared.session = try await RequestManager.shared.post(
            url: "/users/session", input: input, query: query
        )
        return SessionManager.shared.session!
    }

    public func pick(_ picks: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [UserResultPick]) async throws -> Session {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [UserResultPick]) -> Self {
        if query == nil { query = UserSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [UserResultPick]) async throws -> Session {
        return try await self.omit(omits).exec()
    }
}

public struct UserClient {

    fileprivate init() { }

    public func create(_ input: UserCreateInput) -> UserCreateRequest {
        return UserCreateRequest(input: input)
    }

    public func create(
        username: String, 
        password: String, 
        phoneNum: String? = nil
    ) -> UserCreateRequest {
        let input = UserCreateInput(
            username: username,
            password: password,
            phoneNum: phoneNum
        )
        return create(input)
    }

    public func create(_ input: UserCreateInput) async throws -> User {
        let request: UserCreateRequest = self.create(input)
        return try await request.exec()
    }

    public func create(
        username: String, 
        password: String, 
        phoneNum: String? = nil
    ) async throws -> User {
        let request: UserCreateRequest = self.create(
            username: username,
            password: password,
            phoneNum: phoneNum
        )
        return try await request.exec()
    }

    public func update(_ id: String, _ input: UserUpdateInput) -> UserUpdateRequest {
        return UserUpdateRequest(id: id, input: input)
    }

    public func update(
        _ id: String,
        username: String? = nil, 
        password: String? = nil, 
        phoneNum: String? = nil
    ) -> UserUpdateRequest {
        let input = UserUpdateInput(
            username: username,
            password: password,
            phoneNum: phoneNum
        )
        return update(id, input)
    }

    public func update(_ id: String, _ input: UserUpdateInput) async throws -> User {
        let request: UserUpdateRequest = self.update(id, input)
        return try await request.exec()
    }

    public func update(
        _ id: String,
        username: String? = nil, 
        password: String? = nil, 
        phoneNum: String? = nil
    ) async throws -> User {
        let request: UserUpdateRequest = self.update(
            id,
            username: username,
            password: password,
            phoneNum: phoneNum
        )
        return try await request.exec()
    }

    public func delete(_ id: String) async throws {
        let request = UserDeleteRequest(id: id)
        return try await request.exec()
    }

    public func id(_ id: String) -> UserIDRequest {
        return UserIDRequest(id: id)
    }
    public func id(_ id: String) async throws -> User {
        let request = UserIDRequest(id: id)
        return try await request.exec()
    }

    public func find(_ query: UserListQuery? = nil) -> UserListRequest {
        return UserListRequest(query: query)
    }

    public func find(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) -> UserListRequest {
        let query = UserListQuery()
        query.id = id
        query.username = username
        query.phoneNum = phoneNum
        return UserListRequest(query: query)
    }

    public func find(_ query: UserListQuery? = nil) async throws -> [User] {
        let request = UserListRequest(query: query)
        return try await request.exec()
    }

    public func find(
        id: StringQuery? = nil,
        username: StringQuery? = nil,
        phoneNum: StringQuery? = nil
    ) async throws -> [User] {
        let query = UserListQuery()
        query.id = id
        query.username = username
        query.phoneNum = phoneNum
        let request = UserListRequest(query: query)
        return try await request.exec()
    }

    public func upsert(query: UserSeekQuery, data: UserUpdateInput) async throws -> User {
        let input = UserQueryData(_query: query, _data: data)
        let request = UserUpsertRequest(input: input)
        return try await request.exec()
    }

    public func createMany(input: [UserCreateInput], query: UserSingleQuery? = nil) -> UserCreateManyRequest {
        return UserCreateManyRequest(input: input, query: query)
    }

    public func createMany(input: [UserCreateInput], query: UserSingleQuery? = nil) async throws -> [User] {
        let request = UserCreateManyRequest(input: input, query: query)
        return try await request.exec()
    }

    public func updateMany(query: UserSeekQuery, data: UserUpdateInput) async throws -> [User] {
        let input = UserQueryData(_query: query, _data: data)
        let request = UserUpdateManyRequest(input: input)
        return try await request.exec()
    }

    public func delete(_ query: UserSeekQuery? = nil) async throws {
        let request = UserDeleteManyRequest(query: query)
        return try await request.exec()
    }

    public func signIn(input: UserSessionInput, query: UserSingleQuery? = nil) async throws -> Session {
        let request = UserSignInRequest(input: input, query: query)
        return try await request.exec()
    }
}

public class ArticleCreateRequest {
    internal var input: ArticleCreateInput
    internal var query: ArticleSingleQuery?

    internal init(input: ArticleCreateInput, query: ArticleSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> Article {
        return try await RequestManager.shared.post(
            url: "/articles", input: input, query: query
        )
    }

    public func pick(_ picks: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [ArticleResultPick]) async throws -> Article {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [ArticleResultPick]) async throws -> Article {
        return try await self.omit(omits).exec()
    }
}

public class ArticleUpdateRequest {
    internal var id: String
    internal var input: ArticleUpdateInput
    internal var query: ArticleSingleQuery?

    internal init(id: String, input: ArticleUpdateInput, query: ArticleSingleQuery? = nil) {
        self.id = id
        self.input = input
        self.query = query    }

    internal func exec() async throws -> Article {
        return try await RequestManager.shared.patch(
            url: "/articles/\(id)", input: input, query: query
        )
    }

    public func pick(_ picks: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [ArticleResultPick]) async throws -> Article {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [ArticleResultPick]) async throws -> Article {
        return try await self.omit(omits).exec()
    }
}

public class ArticleDeleteRequest {
    internal var id: String

    internal init(id: String) {
        self.id = id
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/articles/\(id)"
        )
    }
}

public class ArticleIDRequest {
    internal var id: String
    internal var query: ArticleSingleQuery?

    internal init(id: String, query: ArticleSingleQuery? = nil) {
        self.id = id
        self.query = query
    }

    internal func exec() async throws -> Article {
        return try await RequestManager.shared.get(
            url: "/articles/\(id)", query: query
        )!
    }

    public func pick(_ picks: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [ArticleResultPick]) async throws -> Article {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [ArticleResultPick]) async throws -> Article {
        return try await self.omit(omits).exec()
    }
}

public class ArticleUpsertRequest {
    internal var input: ArticleQueryData
    internal var query: ArticleSeekQuery?

    internal init(input: ArticleQueryData, query: ArticleSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> Article {
        return try await RequestManager.shared.post(
            url: "/articles",
            input: ArticleManyRequestType.upsert.getContent(input: self.input),
            query: self.query
        )
    }
}

public class ArticleCreateManyRequest {
    internal var input: [ArticleCreateInput]
    internal var query: ArticleSingleQuery?

    internal init(input: [ArticleCreateInput], query: ArticleSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> [Article] {
        return try await RequestManager.shared.post(
            url: "/articles", input: ArticleManyRequestType.create.getContent(input: self.input), query: query
        )
    }

    public func pick(_ picks: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [ArticleResultPick]) async throws -> [Article] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [ArticleResultPick]) async throws -> [Article] {
        return try await self.omit(omits).exec()
    }
}

public class ArticleUpdateManyRequest {
    internal var input: ArticleQueryData
    internal var query: ArticleSeekQuery?

    internal init(input: ArticleQueryData, query: ArticleSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> [Article] {
        return try await RequestManager.shared.patch(
            url: "/articles", input: ArticleManyRequestType.update.getContent(input: self.input), query: self.query
        )
    }
}

public class ArticleDeleteManyRequest {
    internal var query: ArticleSeekQuery?

    internal init(query: ArticleSeekQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/articles",
            query: self.query
        )
    }
}

public class ArticleListRequest {
    internal var query: ArticleListQuery?

    internal init(query: ArticleListQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws -> [Article] {
        return try await RequestManager.shared.get(
            url: "/articles", query: query
        )!
    }

    public func order(_ order: ArticleSortOrder) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.order(order)
        return self
    }

    public func order(_ orders: [ArticleSortOrder]) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.order(orders)
        return self
    }

    public func order(_ order: ArticleSortOrder) async throws -> [Article] {
        return try await self.order(order).exec()
    }

    public func order(_ orders: [ArticleSortOrder]) async throws -> [Article] {
        return try await self.order(orders).exec()
    }

    public func skip(_ skip: Int) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.skip(skip)
        return self
    }

    public func skip(_ skip: Int) async throws -> [Article] {
        return try await self.skip(skip).exec()
    }

    public func limit(_ limit: Int) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.limit(limit)
        return self
    }

    public func limit(_ limit: Int) async throws -> [Article] {
        return try await self.limit(limit).exec()
    }

    public func pageSize(_ pageSize: Int) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.pageSize(pageSize)
        return self
    }

    public func pageSize(_ pageSize: Int) async throws -> [Article] {
        return try await self.pageSize(pageSize).exec()
    }

    public func pageNo(_ pageNo: Int) -> ArticleListRequest {
        if query == nil { query = ArticleListQuery() }
        query = query!.pageNo(pageNo)
        return self
    }

    public func pageNo(_ pageNo: Int) async throws -> [Article] {
        return try await self.pageNo(pageNo).exec()
    }
    public func pick(_ picks: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleListQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [ArticleResultPick]) async throws -> [Article] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [ArticleResultPick]) -> Self {
        if query == nil { query = ArticleListQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [ArticleResultPick]) async throws -> [Article] {
        return try await self.omit(omits).exec()
    }
}

public struct ArticleClient {

    fileprivate init() { }

    public func create(_ input: ArticleCreateInput) -> ArticleCreateRequest {
        return ArticleCreateRequest(input: input)
    }

    public func create(
        title: String, 
        content: String? = nil
    ) -> ArticleCreateRequest {
        let input = ArticleCreateInput(
            title: title,
            content: content
        )
        return create(input)
    }

    public func create(_ input: ArticleCreateInput) async throws -> Article {
        let request: ArticleCreateRequest = self.create(input)
        return try await request.exec()
    }

    public func create(
        title: String, 
        content: String? = nil
    ) async throws -> Article {
        let request: ArticleCreateRequest = self.create(
            title: title,
            content: content
        )
        return try await request.exec()
    }

    public func update(_ id: String, _ input: ArticleUpdateInput) -> ArticleUpdateRequest {
        return ArticleUpdateRequest(id: id, input: input)
    }

    public func update(
        _ id: String,
        title: String? = nil, 
        content: String? = nil
    ) -> ArticleUpdateRequest {
        let input = ArticleUpdateInput(
            title: title,
            content: content
        )
        return update(id, input)
    }

    public func update(_ id: String, _ input: ArticleUpdateInput) async throws -> Article {
        let request: ArticleUpdateRequest = self.update(id, input)
        return try await request.exec()
    }

    public func update(
        _ id: String,
        title: String? = nil, 
        content: String? = nil
    ) async throws -> Article {
        let request: ArticleUpdateRequest = self.update(
            id,
            title: title,
            content: content
        )
        return try await request.exec()
    }

    public func delete(_ id: String) async throws {
        let request = ArticleDeleteRequest(id: id)
        return try await request.exec()
    }

    public func id(_ id: String) -> ArticleIDRequest {
        return ArticleIDRequest(id: id)
    }
    public func id(_ id: String) async throws -> Article {
        let request = ArticleIDRequest(id: id)
        return try await request.exec()
    }

    public func find(_ query: ArticleListQuery? = nil) -> ArticleListRequest {
        return ArticleListRequest(query: query)
    }

    public func find(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) -> ArticleListRequest {
        let query = ArticleListQuery()
        query.id = id
        query.title = title
        query.content = content
        return ArticleListRequest(query: query)
    }

    public func find(_ query: ArticleListQuery? = nil) async throws -> [Article] {
        let request = ArticleListRequest(query: query)
        return try await request.exec()
    }

    public func find(
        id: StringQuery? = nil,
        title: StringQuery? = nil,
        content: StringQuery? = nil
    ) async throws -> [Article] {
        let query = ArticleListQuery()
        query.id = id
        query.title = title
        query.content = content
        let request = ArticleListRequest(query: query)
        return try await request.exec()
    }

    public func upsert(query: ArticleSeekQuery, data: ArticleUpdateInput) async throws -> Article {
        let input = ArticleQueryData(_query: query, _data: data)
        let request = ArticleUpsertRequest(input: input)
        return try await request.exec()
    }

    public func createMany(input: [ArticleCreateInput], query: ArticleSingleQuery? = nil) -> ArticleCreateManyRequest {
        return ArticleCreateManyRequest(input: input, query: query)
    }

    public func createMany(input: [ArticleCreateInput], query: ArticleSingleQuery? = nil) async throws -> [Article] {
        let request = ArticleCreateManyRequest(input: input, query: query)
        return try await request.exec()
    }

    public func updateMany(query: ArticleSeekQuery, data: ArticleUpdateInput) async throws -> [Article] {
        let input = ArticleQueryData(_query: query, _data: data)
        let request = ArticleUpdateManyRequest(input: input)
        return try await request.exec()
    }

    public func delete(_ query: ArticleSeekQuery? = nil) async throws {
        let request = ArticleDeleteManyRequest(query: query)
        return try await request.exec()
    }
}

public var users = UserClient()
public var articles = ArticleClient()

