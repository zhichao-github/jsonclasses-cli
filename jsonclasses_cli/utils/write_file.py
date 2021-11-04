from pathlib import Path


def write_file(path: Path, content: str) -> None:
    print('write to ', path)
    print(content)
