from os import getcwd
from pathlib import Path
from importlib import import_module
from click import group, argument, option, echo
from .new import new as execute_new
from .upgrade import upgrade as execute_upgrade
from .package import package as execute_package


@group()
def app():
    pass


@app.command()
def upgrade():
    execute_upgrade()


@app.command()
@argument('name')
def new(name: str):
    dest = Path(getcwd()) / name
    execute_new(dest)


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
