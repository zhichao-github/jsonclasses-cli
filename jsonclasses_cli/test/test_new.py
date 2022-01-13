from __future__ import annotations
from unittest import TestCase
from tempfile import TemporaryDirectory
from pathlib import Path
from ..new import new


class TestNew(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        cls.temp_dir = TemporaryDirectory()
        cls.temp_path = Path(str(cls.temp_dir.name)) / 'my_new_app'

    @classmethod
    def tearDownClass(cls) -> None:
        pass

    def setUp(self) -> None:
        self.__class__.temp_dir.cleanup()


    def test_new_create_all_filed(self) -> None:
        new(self.temp_path, None, None, None, None, None, True)
        app = Path(self.temp_path) / 'app.py'
        print(app.read_text())
