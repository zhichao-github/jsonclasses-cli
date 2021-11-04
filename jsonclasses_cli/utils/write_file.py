from pathlib import Path


def write_file(path: Path, content: str) -> None:

    if not path.parent.exists():
        path.parent.mkdir()
    with open(path, 'w') as file:
        file.write(content)
