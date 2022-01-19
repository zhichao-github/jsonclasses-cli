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
        cls.cls_dir = Path(getcwd()) / 'tests' / 'classes' / 'user_article'
        cls.data_dir = Path(getcwd()) / 'tests' / 'data_package'
        cls.ts_path = cls.temp_path/'packages' / 'ts'
    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp_dir.cleanup()


    def test_create_user_article_ts_package(self) -> None:
        user_article_path = self.cls_dir / 'app.py'
        package(self.temp_path, user_article_path, 'ts', True)
        ts_path = self.temp_path/'packages' / 'ts'
        self.assertTrue(ts_path.exists())


    def test_user_article_ts_package_api(self) -> None:
        api_path =  self.ts_path  / 'src' / 'index.ts'
        test_api_path = self.data_dir / 'user_article_api.ts'
        self.assertEqual(api_path.read_text(), test_api_path.read_text())

