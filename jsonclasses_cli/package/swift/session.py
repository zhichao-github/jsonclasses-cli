from .codable_struct import codable_struct, codable_struct_item


def session(items: list[str]) -> str:
    return codable_struct('Session', [
        codable_struct_item('public', 'let', 'token', 'String', False),
        *items
    ])
