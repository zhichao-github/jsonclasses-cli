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
        cls.cls_dir = Path(getcwd()) / 'tests' / 'classes' / 'simple_song'
        cls.data_dir = Path(getcwd()) / 'tests' / 'data_package'
        cls.ts_path = cls.temp_path/'packages' / 'ts'
    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp_dir.cleanup()


    def test_create_simple_song_ts_package(self) -> None:

        simple_song_path = self.cls_dir / 'app.py'

        package(self.temp_path, simple_song_path, 'ts', True)
        ts_path = self.temp_path/'packages' / 'ts'
        self.assertTrue(ts_path.exists())


    def test_simple_song_ts_package_gitignore(self) -> None:
        gitignore_path = self.ts_path / '.gitignore'
        test_gitignore_path = self.data_dir / '.gitignore'
        self.assertEqual(gitignore_path.read_text(), test_gitignore_path.read_text())

    def test_simple_song_ts_package_json(self) -> None:
        package_json_path =  self.ts_path  / 'package.json'
        test_package_json_path = self.data_dir / 'package.json'
        self.assertEqual(package_json_path.read_text(), test_package_json_path.read_text())

    def test_simple_song_ts_package_config(self) -> None:
        config_path =  self.ts_path / 'tsconfig.json'
        test_config_path = self.data_dir / 'tsconfig.json'
        self.assertEqual(config_path.read_text(), test_config_path.read_text())

    def test_simple_song_ts_package_api(self) -> None:
        api_path =  self.ts_path  / 'src' / 'index.ts'
        test_api_path = self.data_dir / 'simple_song_api.ts'
        print(api_path.read_text())
        self.assertEqual(api_path.read_text(), test_api_path.read_text())
