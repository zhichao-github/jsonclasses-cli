def string_query() -> str:
    return """
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

export type StringQuery = string | StringContainsQuery | StringPrefixQuery | StringSuffixQuery | StringMatchQuery
    """.strip() + "\n"
