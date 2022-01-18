from __future__ import annotations
from unittest import TestCase
from tempfile import TemporaryDirectory
from pathlib import Path
from jsonclasses_cli.new import (new, conf_content, gitignore_content, readme_content,
                   app_content, mypy_content, req_content)


class TestNew(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        cls.temp_dir = TemporaryDirectory()

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temp_dir.cleanup()

    def setUp(self) -> None:
        self.temp_path = Path(str(self.temp_dir.name)) / "new_app"


    def test_new_create_all_filed(self) -> None:
        new(self.temp_path, None, None, None, None, None, True)
        app = self.temp_path / 'app.py'
        requirements = self.temp_path / 'requirements.txt'
        config = self.temp_path / 'config.json'
        mypy = self.temp_path / 'mypy.ini'
        gitignore = self.temp_path / '.gitignore'
        read_me = self.temp_path / 'README.md'
        self.assertTrue(app.is_file(), app.name)
        self.assertTrue(requirements.is_file(), requirements.name)
        self.assertTrue(config.is_file(), config.name)
        self.assertTrue(mypy.is_file(), mypy.name)
        self.assertTrue(gitignore.is_file(), gitignore.name)
        self.assertTrue(read_me.is_file(), read_me.name)

    def test_new_app_content_without_admin_and_user(self) -> None:
        new(self.temp_path, None, None, None, None, None, True)
        app = Path(self.temp_path) / 'app.py'
        self.assertEqual(app.read_text(), app_content(False, False))

    def test_new_app_content_without_admin(self) -> None:
        new(self.temp_path, None, True, None, None, None, True)
        app = Path(self.temp_path) / 'app.py'
        self.assertEqual(app.read_text(), app_content(True, False))

    def test_new_app_content_without_user(self) -> None:
        new(self.temp_path, None, None, True, None, None, True)
        app = Path(self.temp_path) / 'app.py'
        self.assertEqual(app.read_text(), app_content(False, True))

    def test_new_app_content_with_user_and_admin(self) -> None:
        new(self.temp_path, None, True, True, None, None, True)
        app = Path(self.temp_path) / 'app.py'
        self.assertEqual(app.read_text(), app_content(True, True))

    def test_new_config_mypy_gitignore_and_readme_content(self) -> None:
        new(self.temp_path, None, None, None, None, None, True)
        # config = Path(self.temp_path) / 'config.json'
        mypy = Path(self.temp_path) / 'mypy.ini'
        gitignore = Path(self.temp_path) / '.gitignore'
        read_me = Path(self.temp_path) / 'README.md'
        # self.assertEqual(config.read_text(), conf_content(config.name))
        self.assertEqual(mypy.read_text(), mypy_content())
        self.assertEqual(gitignore.read_text(), gitignore_content())
        self.assertEqual(read_me.read_text(), readme_content(read_me.parent))

    # test command
    # def test_new_create_app_use_command(self) -> None:
    #     runner = CliRunner()
    #     with runner.isolated_filesystem(self.temp_path):
    #         result = runner.invoke(command_new, 'test', input='No\nNo\nNo\nNo\n', color=True)
    #         print(self.temp_path)
    #         print(result.output)
