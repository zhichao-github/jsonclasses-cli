from os import getcwd
from pathlib import Path
from importlib import import_module
from typing import Literal
from click import group, argument, option, echo, Choice
from .new import new as execute_new
from .upgrade import upgrade as execute_upgrade
from .package import package as execute_package
from .version import version


def print_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    echo(f'JSONClasses CLI {version}')
    ctx.exit()


@group()
@option('-v', '--version', is_flag=True, callback=print_version, expose_value=False, is_eager=True)
def app():
    pass


@app.command()
def upgrade():
    execute_upgrade()


@app.command()
@argument('name')
@option('-i', '--interactive/--no-interactive', ' /-I', default=True)
@option('--http-framework', type=Choice(['flask', 'fastapi'], case_sensitive=False), required=False)
@option('-u', '--include-user', is_flag=True, required=False, default=None)
@option('-a', '--include-admin', is_flag=True, required=False, default=None)
@option('-t', '--include-template', is_flag=True, required=False, default=None)
def new(name: str,
        interactive: bool | None,
        http_framework: Literal['flask', 'fastapi'] | None,
        include_user: bool | None,
        include_admin: bool | None,
        include_template: bool | None):
    execute_new(Path(getcwd()) / name,
                interactive=interactive,
                http_framework=http_framework,
                include_user=include_user,
                include_admin=include_admin,
                include_template=include_template)


@app.command()
@argument('lang')
@argument('file', default='app.py')
def package(lang: str, file: str | None):
    dest = Path(getcwd())
    app_file = dest / file
    app_module = import_module('app', app_file)
    app = app_module.app
    execute_package(dest, app, lang)


if __name__ == '__main__':
    app()
