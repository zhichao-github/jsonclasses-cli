from click import group, argument, option, echo


@group()
def app():
    pass


@app.command()
@argument('name')
def new(name: str):
    echo('New')


@app.command()
def package():
    echo('Package')


if __name__ == '__main__':
    app()
