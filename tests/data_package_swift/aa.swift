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

public class SimpleSongCreateInput: Codable {
    public var name: String

    public init(
        name: String
    ) {
        self.name = name
    }
}

public class SimpleSongUpdateInput: Codable {
    public var name: String?

    public init(
        name: String? = nil
    ) {
        self.name = name
    }
}

public enum SimpleSongSortOrder: String, Codable {
    case name = "name"
    case nameDesc = "-name"
    case createdAt = "createdAt"
    case createdAtDesc = "-createdAt"
    case updatedAt = "updatedAt"
    case updatedAtDesc = "-updatedAt"
}

public prefix func -(rhs: SimpleSongSortOrder) -> SimpleSongSortOrder {
    if rhs.rawValue.starts(with: "-") {
        return SimpleSongSortOrder(rawValue: String(rhs.rawValue.dropFirst()))!
    } else {
        return SimpleSongSortOrder(rawValue: "-" + rhs.rawValue)!
    }
}

public enum SimpleSongResultPick: String, Codable {
    case id = "id"
    case name = "name"
    case createdAt = "createdAt"
    case updatedAt = "updatedAt"
}

public enum SimpleSongManyRequestType: Codable {
    case update
    case create
    case upsert

    func getContent(input: SimpleSongQueryData) -> Dictionary<String, SimpleSongQueryData> {
        if self  == .update {
            return ["_update": input]
        }
        else if self == .upsert {
            return ["_upsert": input]
        }
        return [String: SimpleSongQueryData]()
    }

    func getContent(input: [SimpleSongCreateInput]) -> Dictionary<String, [SimpleSongCreateInput]> {
        if self  == .create {
            return ["_create": input]
        }
        return [String: [SimpleSongCreateInput]]()
    }
}

public class SimpleSongSingleQuery: Codable {
    fileprivate var _pick: [SimpleSongResultPick]? = nil
    fileprivate var _omit: [SimpleSongResultPick]? = nil

    public static func pick(_ picks: [SimpleSongResultPick]) -> SimpleSongSingleQuery {
        let instance = SimpleSongSingleQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> SimpleSongSingleQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [SimpleSongResultPick]) -> SimpleSongSingleQuery {
        let instance = SimpleSongSingleQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> SimpleSongSingleQuery {
        _omit = omits
        return self
    }
}

public class SimpleSongSeekQuery: Codable {
    public var id: StringQuery? = nil
    public var name: StringQuery? = nil
    public var createdAt: DateQuery? = nil
    public var updatedAt: DateQuery? = nil

    public static func `where`(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) -> SimpleSongSeekQuery {
        let instance = SimpleSongSeekQuery()
        instance.id = id
        instance.name = name
        instance.createdAt = createdAt
        instance.updatedAt = updatedAt
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) -> SimpleSongSeekQuery {
        if id != nil { self.id = id }
        if name != nil { self.name = name }
        if createdAt != nil { self.createdAt = createdAt }
        if updatedAt != nil { self.updatedAt = updatedAt }
        return self
    }
}

public class SimpleSongQueryData: Codable {
    fileprivate var _query: SimpleSongSeekQuery
    fileprivate var _data: SimpleSongUpdateInput

    public init(
        _query: SimpleSongSeekQuery,
        _data: SimpleSongUpdateInput
    ) {
        self._query = _query
        self._data = _data
    }
}

public class SimpleSongListQuery: Codable {
    public var id: StringQuery? = nil
    public var name: StringQuery? = nil
    public var createdAt: DateQuery? = nil
    public var updatedAt: DateQuery? = nil
    fileprivate var _order: [SimpleSongSortOrder]? = nil
    fileprivate var _limit: Int? = nil
    fileprivate var _skip: Int? = nil
    fileprivate var _pageNo: Int? = nil
    fileprivate var _pageSize: Int? = nil
    fileprivate var _pick: [SimpleSongResultPick]? = nil
    fileprivate var _omit: [SimpleSongResultPick]? = nil

    public static func `where`(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance.id = id
        instance.name = name
        instance.createdAt = createdAt
        instance.updatedAt = updatedAt
        return instance
    }

    public func `where`(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) -> SimpleSongListQuery {
        if id != nil { self.id = id }
        if name != nil { self.name = name }
        if createdAt != nil { self.createdAt = createdAt }
        if updatedAt != nil { self.updatedAt = updatedAt }
        return self
    }

    public static func order(_ order: SimpleSongSortOrder) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._order = [order]
        return instance
    }

    public static func order(_ orders: [SimpleSongSortOrder]) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._order = orders
        return instance
    }

    public func order(_ order: SimpleSongSortOrder) -> SimpleSongListQuery {
        if _order == nil { _order = [] }
        _order!.append(order)
        return self
    }

    public func order(_ orders: [SimpleSongSortOrder]) -> SimpleSongListQuery {
        if _order == nil { _order = [] }
        _order!.append(contentsOf: orders)
        return self
    }

    public static func limit(_ limit: Int) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._limit = limit
        return instance
    }

    public func limit(_ limit: Int) -> SimpleSongListQuery {
        _limit = limit
        return self
    }
    public static func skip(_ skip: Int) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._skip = skip
        return instance
    }

    public func skip(_ skip: Int) -> SimpleSongListQuery {
        _skip = skip
        return self
    }
    public static func pageNo(_ pageNo: Int) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._pageNo = pageNo
        return instance
    }

    public func pageNo(_ pageNo: Int) -> SimpleSongListQuery {
        _pageNo = pageNo
        return self
    }
    public static func pageSize(_ pageSize: Int) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._pageSize = pageSize
        return instance
    }

    public func pageSize(_ pageSize: Int) -> SimpleSongListQuery {
        _pageSize = pageSize
        return self
    }

    public static func pick(_ picks: [SimpleSongResultPick]) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._pick = picks
        return instance
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> SimpleSongListQuery {
        _pick = picks
        return self
    }

    public static func omit(_ omits: [SimpleSongResultPick]) -> SimpleSongListQuery {
        let instance = SimpleSongListQuery()
        instance._omit = omits
        return instance
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> SimpleSongListQuery {
        _omit = omits
        return self
    }
}

public class SimpleSong: Codable {
    public let id: String!
    public let name: String!
    public let createdAt: Date!
    public let updatedAt: Date!

    public init(
        id: String,
        name: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
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

public class SimpleSongCreateRequest {
    internal var input: SimpleSongCreateInput
    internal var query: SimpleSongSingleQuery?

    internal init(input: SimpleSongCreateInput, query: SimpleSongSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> SimpleSong {
        return try await RequestManager.shared.post(
            url: "/simple-songs", input: input, query: query
        )
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.omit(omits).exec()
    }
}

public class SimpleSongUpdateRequest {
    internal var id: String
    internal var input: SimpleSongUpdateInput
    internal var query: SimpleSongSingleQuery?

    internal init(id: String, input: SimpleSongUpdateInput, query: SimpleSongSingleQuery? = nil) {
        self.id = id
        self.input = input
        self.query = query    }

    internal func exec() async throws -> SimpleSong {
        return try await RequestManager.shared.patch(
            url: "/simple-songs/\(id)", input: input, query: query
        )
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.omit(omits).exec()
    }
}

public class SimpleSongDeleteRequest {
    internal var id: String

    internal init(id: String) {
        self.id = id
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/simple-songs/\(id)"
        )
    }
}

public class SimpleSongIDRequest {
    internal var id: String
    internal var query: SimpleSongSingleQuery?

    internal init(id: String, query: SimpleSongSingleQuery? = nil) {
        self.id = id
        self.query = query
    }

    internal func exec() async throws -> SimpleSong {
        return try await RequestManager.shared.get(
            url: "/simple-songs/\(id)", query: query
        )!
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [SimpleSongResultPick]) async throws -> SimpleSong {
        return try await self.omit(omits).exec()
    }
}

public class SimpleSongUpsertRequest {
    internal var input: SimpleSongQueryData
    internal var query: SimpleSongSeekQuery?

    internal init(input: SimpleSongQueryData, query: SimpleSongSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> SimpleSong {
        return try await RequestManager.shared.post(
            url: "/simple-songs",
            input: SimpleSongManyRequestType.upsert.getContent(input: self.input),
            query: self.query
        )
    }
}

public class SimpleSongCreateManyRequest {
    internal var input: [SimpleSongCreateInput]
    internal var query: SimpleSongSingleQuery?

    internal init(input: [SimpleSongCreateInput], query: SimpleSongSingleQuery? = nil) {
        self.input = input
        self.query = query    }

    internal func exec() async throws -> [SimpleSong] {
        return try await RequestManager.shared.post(
            url: "/simple-songs", input: SimpleSongManyRequestType.create.getContent(input: self.input), query: query
        )
    }

    public func pick(_ picks: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [SimpleSongResultPick]) async throws -> [SimpleSong] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongSingleQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [SimpleSongResultPick]) async throws -> [SimpleSong] {
        return try await self.omit(omits).exec()
    }
}

public class SimpleSongUpdateManyRequest {
    internal var input: SimpleSongQueryData
    internal var query: SimpleSongSeekQuery?

    internal init(input: SimpleSongQueryData, query: SimpleSongSeekQuery? = nil) {
        self.input = input
        self.query = query
    }

    internal func exec() async throws -> [SimpleSong] {
        return try await RequestManager.shared.patch(
            url: "/simple-songs", input: SimpleSongManyRequestType.update.getContent(input: self.input), query: self.query
        )
    }
}

public class SimpleSongDeleteManyRequest {
    internal var query: SimpleSongSeekQuery?

    internal init(query: SimpleSongSeekQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws {
        return try await RequestManager.shared.delete(
            url: "/simple-songs",
            query: self.query
        )
    }
}

public class SimpleSongListRequest {
    internal var query: SimpleSongListQuery?

    internal init(query: SimpleSongListQuery? = nil) {
        self.query = query
    }

    internal func exec() async throws -> [SimpleSong] {
        return try await RequestManager.shared.get(
            url: "/simple-songs", query: query
        )!
    }

    public func order(_ order: SimpleSongSortOrder) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.order(order)
        return self
    }

    public func order(_ orders: [SimpleSongSortOrder]) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.order(orders)
        return self
    }

    public func order(_ order: SimpleSongSortOrder) async throws -> [SimpleSong] {
        return try await self.order(order).exec()
    }

    public func order(_ orders: [SimpleSongSortOrder]) async throws -> [SimpleSong] {
        return try await self.order(orders).exec()
    }

    public func skip(_ skip: Int) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.skip(skip)
        return self
    }

    public func skip(_ skip: Int) async throws -> [SimpleSong] {
        return try await self.skip(skip).exec()
    }

    public func limit(_ limit: Int) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.limit(limit)
        return self
    }

    public func limit(_ limit: Int) async throws -> [SimpleSong] {
        return try await self.limit(limit).exec()
    }

    public func pageSize(_ pageSize: Int) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.pageSize(pageSize)
        return self
    }

    public func pageSize(_ pageSize: Int) async throws -> [SimpleSong] {
        return try await self.pageSize(pageSize).exec()
    }

    public func pageNo(_ pageNo: Int) -> SimpleSongListRequest {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.pageNo(pageNo)
        return self
    }

    public func pageNo(_ pageNo: Int) async throws -> [SimpleSong] {
        return try await self.pageNo(pageNo).exec()
    }



    public func pick(_ picks: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.pick(picks)
        return self
    }

    public func pick(_ picks: [SimpleSongResultPick]) async throws -> [SimpleSong] {
        return try await self.pick(picks).exec()
    }

    public func omit(_ omits: [SimpleSongResultPick]) -> Self {
        if query == nil { query = SimpleSongListQuery() }
        query = query!.omit(omits)
        return self
    }

    public func omit(_ omits: [SimpleSongResultPick]) async throws -> [SimpleSong] {
        return try await self.omit(omits).exec()
    }
}

public struct SimpleSongClient {

    fileprivate init() { }

    public func create(_ input: SimpleSongCreateInput) -> SimpleSongCreateRequest {
        return SimpleSongCreateRequest(input: input)
    }

    public func create(
        name: String
    ) -> SimpleSongCreateRequest {
        let input = SimpleSongCreateInput(
            name: name
        )
        return create(input)
    }

    public func create(_ input: SimpleSongCreateInput) async throws -> SimpleSong {
        let request: SimpleSongCreateRequest = self.create(input)
        return try await request.exec()
    }

    public func create(
        name: String
    ) async throws -> SimpleSong {
        let request: SimpleSongCreateRequest = self.create(
            name: name
        )
        return try await request.exec()
    }

    public func update(_ id: String, _ input: SimpleSongUpdateInput) -> SimpleSongUpdateRequest {
        return SimpleSongUpdateRequest(id: id, input: input)
    }

    public func update(
        _ id: String,
        name: String? = nil
    ) -> SimpleSongUpdateRequest {
        let input = SimpleSongUpdateInput(
            name: name
        )
        return update(id, input)
    }

    public func update(_ id: String, _ input: SimpleSongUpdateInput) async throws -> SimpleSong {
        let request: SimpleSongUpdateRequest = self.update(id, input)
        return try await request.exec()
    }

    public func update(
        _ id: String,
        name: String? = nil
    ) async throws -> SimpleSong {
        let request: SimpleSongUpdateRequest = self.update(
            id,
            name: name
        )
        return try await request.exec()
    }

    public func delete(_ id: String) async throws {
        let request = SimpleSongDeleteRequest(id: id)
        return try await request.exec()
    }

    public func id(_ id: String) -> SimpleSongIDRequest {
        return SimpleSongIDRequest(id: id)
    }

    public func id(_ id: String) async throws -> SimpleSong {
        let request = SimpleSongIDRequest(id: id)
        return try await request.exec()
    }


    public func find(_ query: SimpleSongListQuery? = nil) -> SimpleSongListRequest {
        return SimpleSongListRequest(query: query)
    }

    public func find(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) -> SimpleSongListRequest {
        let query = SimpleSongListQuery()
        query.id = id
        query.name = name
        query.createdAt = createdAt
        query.updatedAt = updatedAt
        return SimpleSongListRequest(query: query)
    }

    public func find(_ query: SimpleSongListQuery? = nil) async throws -> [SimpleSong] {
        let request = SimpleSongListRequest(query: query)
        return try await request.exec()
    }

    public func find(
        id: StringQuery? = nil,
        name: StringQuery? = nil,
        createdAt: DateQuery? = nil,
        updatedAt: DateQuery? = nil
    ) async throws -> [SimpleSong] {
        let query = SimpleSongListQuery()
        query.id = id
        query.name = name
        query.createdAt = createdAt
        query.updatedAt = updatedAt
        let request = SimpleSongListRequest(query: query)
        return try await request.exec()
    }

    public func upsert(query: SimpleSongSeekQuery, data: SimpleSongUpdateInput) async throws -> SimpleSong {
        let input = SimpleSongQueryData(_query: query, _data: data)
        let request = SimpleSongUpsertRequest(input: input)
        return try await request.exec()
    }

    public func createMany(input: [SimpleSongCreateInput], query: SimpleSongSingleQuery? = nil) -> SimpleSongCreateManyRequest {
        return SimpleSongCreateManyRequest(input: input, query: query)
    }

    public func createMany(input: [SimpleSongCreateInput], query: SimpleSongSingleQuery? = nil) async throws -> [SimpleSong] {
        let request = SimpleSongCreateManyRequest(input: input, query: query)
        return try await request.exec()
    }

    public func updateMany(query: SimpleSongSeekQuery, data: SimpleSongUpdateInput) async throws -> [SimpleSong] {
        let input = SimpleSongQueryData(_query: query, _data: data)
        let request = SimpleSongUpdateManyRequest(input: input)
        return try await request.exec()
    }

    public func delete(_ query: SimpleSongSeekQuery? = nil) async throws {
        let request = SimpleSongDeleteManyRequest(query: query)
        return try await request.exec()
    }
}

public var simpleSongs = SimpleSongClient()
