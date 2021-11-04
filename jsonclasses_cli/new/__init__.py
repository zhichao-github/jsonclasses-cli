from typing import Literal
from pathlib import Path
from rich.prompt import Prompt
from ..utils.yesno import yesno


def new(dest: Path,
        interactive: bool | None,
        http_library: Literal['flask', 'fastapi'] | None,
        include_user: bool | None,
        include_admin: bool | None,
        git_init: bool | None):
    if interactive:
        if http_library is None:
            http_library = Prompt.ask('Which HTTP library would you use?', choices=["Flask", "FastAPI"], default="Flask")
        if include_user is None:
            include_user = yesno(Prompt.ask('Do you want a user model?', choices=['Yes', 'No'], default='Yes'))
        if include_admin is None:
            include_admin = yesno(Prompt.ask('Do you want an admin model?', choices=['Yes', 'No'], default='Yes'))
        if git_init is None:
            git_init = yesno(Prompt.ask('Init git repo?', choices=['Yes', 'No'], default='Yes'))
    else:
        if http_library is None:
            http_library = 'flask'
        if include_user is None:
            include_user = False
        if include_admin is None:
            include_admin = False
        if git_init is None:
            git_init = True
