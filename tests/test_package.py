from __future__ import annotations
from os import chdir, getcwd
from unittest import TestCase
from tempfile import TemporaryDirectory
from pathlib import Path
from jsonclasses_cli.package import package


class TestPackage(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        cls.temp_dir = TemporaryDirectory()
        cls.cls_dir = Path(getcwd()) / 'tests' / 'classes'

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp_dir.cleanup()

    def setUp(self) -> None:
        self.temp_path = Path(str(self.temp_dir.name)) / "app_path"

    # def test_create_simple_song_ts_package(self) -> None:
    #     simple_song_path = self.cls_dir / 'app.py'
    #     package(self.temp_path, simple_song_path, 'ts')
    #     print(simple_song_path)
        # self.assertEqual()
