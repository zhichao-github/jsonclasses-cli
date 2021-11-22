from ...utils.join_lines import join_lines


def codable_enum(name: str, raw_type: str, items: list[str]) -> str:
    lines = [_codable_enum_first_line(name, raw_type), *items, "}"]
    return join_lines(lines, 1)


def _codable_enum_first_line(name: str, raw_type: str) -> str:
    return f"public enum {name}: {raw_type}, Codable {'{'}"


def codable_enum_item(name: str, raw_type: str, value: str) -> str:
    return f"    case {name} = {_wrap_value(value, raw_type)}"


def _wrap_value(value: str, raw_type: str) -> str:
    if raw_type == 'String':
        return '"' + value + '"'
    else:
        return value
