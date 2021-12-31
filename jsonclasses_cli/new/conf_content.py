from random import sample

from jsonclasses_cli.utils.join_lines import join_lines


def conf_content() -> str:
    return join_lines([
        '{',
        _operator_conf,
        '}'
    ])


def _operator_conf() -> str:
    return f"""
    "operator": {'{'}
        "secretKey": "{_randompuncs()}"
    {'}'}
    """.strip() + '/n'


def _randompuncs() -> str:
    ascii_lowercase = 'abcdefghijklmnopqrstuvwxyz'
    ascii_uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    punctuation = r"""!#$%&()*+,-./:;<=>?@[\]^_`{|}~"""
    digits = '0123456789'
    ascii_letters = ascii_lowercase + ascii_uppercase
    return ''.join(sample(punctuation+ascii_letters+digits, 24))
