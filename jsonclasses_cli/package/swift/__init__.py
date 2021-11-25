from pathlib import Path
from jsonclasses.cgraph import CGraph
from .main_program_content import main_program_content
from .gitignore_content import gitignore_content
from .package_content import package_content
from .readme_content import readme_content
from ...utils.write_file import write_file


def swift(dest: Path, cgraph: CGraph):
    dest = _create_dest_dir_if_needed(dest)
    _generate_main_program_file(dest, cgraph)
    _generate_package_file(dest)
    _generate_readme_file(dest)
    _generate_gitignore_file(dest)


def _create_dest_dir_if_needed(dest: Path) -> Path:
    dest = dest / 'packages' / 'swift'
    if not dest.is_dir():
        dest.mkdir(parents=True)
    return dest


def _generate_main_program_file(dest: Path, cgraph: CGraph):
    write_file(dest / 'Sources' / 'API' / 'API.swift', main_program_content(cgraph))


def _generate_package_file(dest: Path):
    write_file(dest / 'Package.swift', package_content())


def _generate_gitignore_file(dest: Path):
    write_file(dest / '.gitignore', gitignore_content())


def _generate_readme_file(dest: Path):
    write_file(dest / 'README.md', readme_content())
