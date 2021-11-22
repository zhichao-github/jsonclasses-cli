def sort_order() -> str:
    return """
enum SortOrder: Int, Codable {
    case asc = 1
    case desc = -1
}
    """.strip() + '\n'
