from pathlib import Path
from jsonclasses.cgraph import CGraph
from ...utils.write_file import write_file


def ts(dest: Path, cgraph: CGraph):
    dest = _create_dest_dir_if_needed(dest)
    _generate_main_program_file(dest, cgraph)


def _create_dest_dir_if_needed(dest: Path) -> Path:
    dest = dest / 'packages' / 'ts'
    if not dest.is_dir():
        dest.mkdir(parents=True)
    return dest


def _generate_main_program_file(dest: Path, cgraph: CGraph):
    write_file(dest / 'API.swift', main_program_content(cgraph))
