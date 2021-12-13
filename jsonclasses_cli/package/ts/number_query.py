def number_query() -> str:
    return ('interface NumberValueQuery {\n'
        '    _gt?: number\n'
        '    _gte?: number\n'
        '    _lt?: number\n'
        '    _lte?: number\n'
        '}\n'
        '\n'
        'export type NumberQuery = number | NumberValueQuery\n'
        )
