from typing import Callable
from ...utils.join_lines import join_lines


def unary_sort_order(
        name: str,
        items: list[str],
        mapper: Callable[[str], str]) -> str:
    return join_lines([
        _unary_sort_order_first_line(name),
        _unary_sort_order_switch_line(),
        *map(lambda item: _case_group(item, mapper), items),
        _unary_sort_order_switch_back_line(),
        _unary_sort_order_last_line()
    ])


def _unary_sort_order_first_line(name: str) -> str:
    return f'public prefix func -(rhs: {name}) -> {name} {"{"}'


def _unary_sort_order_switch_line() -> str:
    return '    switch rhs {'


def _unary_sort_order_switch_back_line() -> str:
    return '    }'


def _unary_sort_order_last_line() -> str:
    return '}'


def _case_group(item: str, desc: Callable[[str], str]) -> str:
    return join_lines([
        f'    case .{item}:',
        f'        return .{desc(item)}',
        f'    case .{desc(item)}:',
        f'        return {item}'
    ])
