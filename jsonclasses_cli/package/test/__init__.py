from pathlib import Path
from jsonclasses.cgraph import CGraph
from .package_json_content import package_json_content
from .tsconfig_json_content import tsconfig_json_content
from .main_program_content import main_program_content
from ...utils.write_file import write_file


def test(dest: Path, cgraph: CGraph):
    dest = _create_dest_dir_if_needed(dest)
    _generate_main_program_file(dest, cgraph)
    _generate_package_json_file(dest)
    _generate_tsconfig_json_file(dest)
    _generate_gitignore_file(dest)


def _create_dest_dir_if_needed(dest: Path) -> Path:
    dest = dest / 'packages' / 'ts1'
    if not dest.is_dir():
        dest.mkdir(parents=True)
    return dest


def _generate_main_program_file(dest: Path, cgraph: CGraph):
    write_file(dest / 'src/index.ts', main_program_content(cgraph))


def _generate_package_json_file(dest: Path):
    write_file(dest / 'package.json', package_json_content(dest))


def _generate_tsconfig_json_file(dest: Path):
    write_file(dest / 'tsconfig.json', tsconfig_json_content())


def _generate_gitignore_file(dest: Path):
    write_file(dest / '.gitignore', tsconfig_json_content())
