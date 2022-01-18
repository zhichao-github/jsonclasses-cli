from typing import Literal
from pathlib import Path
from sys import path
from importlib import import_module
from os.path import splitext
from jsonclasses.cgraph import CGraph
from .kotlin import kotlin
from .swift import swift
from .ts import ts


def package(dest: Path, app_file: Path, lang: Literal['ts', 'swift', 'kotlin']):
    path.append(str(app_file.parent))
    import_module(splitext(app_file.name)[0], str(app_file.parent)).__dict__
    cgraph = CGraph('default')
    match lang:
        case 'swift':
            swift(dest, cgraph)
        case 'kotlin':
            kotlin(dest, cgraph)
        case 'ts':
            ts(dest, cgraph)
