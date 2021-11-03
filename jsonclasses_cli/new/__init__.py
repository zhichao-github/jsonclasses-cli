from typing import Literal
from pathlib import Path


def new(dest: Path,
        interactive: bool | None,
        http_framework: Literal['flask', 'fastapi'] | None,
        include_user: bool | None,
        include_admin: bool | None,
        include_template: bool | None):
    print(http_framework)
