


from pathlib import Path
from inflection import underscore, dasherize


def package_json_content(dest: Path):
    pkg_name = dasherize(underscore(dest.name))
    return ('''
{
    "name": "''' + pkg_name + '''",
    "version": "0.1.0",
    "private": true,
    "description": "This API client package is generated by JSONClasses CLI.",
    "main": "lib/index.js",
    "types": "lib/index.d.ts",
    "author": "",
    "dependencies": {
        "axios": "^0.24.0",
        "qsparser-js": "^1.0.1"
    },
    "devDependencies": {
        "typescript": "^4.4.4"
    }
}''').strip() + '\n'


