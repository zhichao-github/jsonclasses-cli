from ...utils.join_lines import join_lines


InterfaceItem = tuple[str, str, bool]


def interface(name: str, items: list[InterfaceItem]) -> str:
    return join_lines([
        join_lines([
            interface_first_line(name),
            _interface_inst_items(items),
            '}'
        ], 1)
    ], 2)


def interface_first_line(name: str) -> str:
    return f"interface {name} {'{'}"


def interface_type_item(name: str, items: list[str]) -> str:
    return f"type {name} = {' | '.join(items)}"


def interface_include_key_item(name: str, include_type: str) -> str:
    return f"    {name}?: {include_type}"


def interface_pick_omit_items(name: str) -> str:
    return join_lines([
        f"    _pick?: {name}[]",
        f"    _omit?: {name}[]",
    ])


def interface_include_item(name: str) -> str:
    return f"    _include?: {name}[]"


def _interface_inst_items(items: list[InterfaceItem]) -> str:
    return join_lines(map(lambda i: f"    {i[0]}{'?' if i[2] else ''}: {i[1]}", items), 1)


def interface_item(name: str,
                   field_type: str,
                   optional: bool,) -> InterfaceItem:
    return (name, field_type, optional)
