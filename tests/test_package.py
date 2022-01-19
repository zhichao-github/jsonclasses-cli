from __future__ import annotations
from os import chdir, getcwd
from unittest import TestCase
from tempfile import TemporaryDirectory
from pathlib import Path
from unittest.mock import patch
from jsonclasses_cli.package import package
from jsonclasses_cli.package.ts import ts


class TestPackage(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        cls.temp_dir = TemporaryDirectory()
        cls.temp_path = Path(str(cls.temp_dir.name)) / "app_path"
        cls.cls_dir = Path(getcwd()) / 'tests' / 'classes'
        cls.data_dir = Path(getcwd()) / 'tests' / 'data_package'

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp_dir.cleanup()


    def test_create_simple_song_ts_package(self) -> None:
        simple_song_path = self.cls_dir / 'simple_song.py'

        package(self.temp_path, simple_song_path, 'ts', True)
        ts_path = self.temp_path/'packages' / 'ts'
        gitignore_path = ts_path / '.gitignore'
        test_gitignore_path = self.data_dir / '.gitignore'
        package_json_path = ts_path / 'package.json'
        test_package_json_path = self.data_dir / 'package.json'
        config_path = ts_path / 'tsconfig.json'
        test_config_path = self.data_dir / 'tsconfig.json'
        api_path = ts_path/ 'src' / 'index.ts'
        test_api_path = self.data_dir / 'api_data.ts'
        self.assertEqual(gitignore_path.read_text(), test_gitignore_path.read_text())
        self.assertEqual(package_json_path.read_text(), test_package_json_path.read_text())
        self.assertEqual(config_path.read_text(), test_config_path.read_text())
        self.assertEqual(api_path.read_text(), test_api_path.read_text())
