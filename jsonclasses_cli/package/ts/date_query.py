def date_query() -> str:
    return ('interface DateValueQuery {\n'
        '    _gt?: Date\n'
        '    _gte?: Date\n'
        '    _lt?: Date\n'
        '    _lte?: Date\n'
        '    _on?: Date\n'
        '}\n'
        '\n'
        'export type DateQuery = Date | DateValueQuery\n'
        )
