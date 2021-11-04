from typing import Literal


def req_content(http_library: Literal['flask', 'fastapi'],
                include_user: bool,
                include_admin: bool) -> str:
    return """
    """.strip() + '\n'
