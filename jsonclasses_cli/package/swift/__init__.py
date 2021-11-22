from pathlib import Path
from jsonclasses.cgraph import CGraph
from .main_program_content import main_program_content
from ...utils.write_file import write_file


def swift(dest: Path, cgraph: CGraph):
    _create_dest_dir_if_needed(dest)
    _generate_main_program_file(dest, cgraph)


def _create_dest_dir_if_needed(dest: Path):
    dest = dest / 'packages' / 'swift'
    if not dest.is_dir():
        dest.mkdir(parents=True)


def _generate_main_program_file(dest: Path, cgraph: CGraph):
    write_file(dest / 'API.swift', main_program_content(cgraph))
