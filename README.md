# JSONClasses CLI

Command line tool for JSONClasses.

### Install JSONClasses


Install JSONClasses-cli is simple with `pip`.

```sh
pip install jsonclasses-cli
```

### Get a Jsonclasses framework in seconds

To create a project called my-api, run this command:
```sh
jsonclasses new my-api
```

It will create a directory called my-api inside the current folder.
In runing the commad, it will ask you whether you want to create user or admin model, init git repo and rreate a virtual env.
Inside that directory, it will generate the initial project structure:
```
my-api
├── README.md
├── app.py
├── requirements.txt
├── config.json
├── mypy.ini
└── .gitignore
```

Then you can open your project folder:
```sh
cd my-api
```

And install the transitive dependencies:
```
python3 -m venv .venv   # if you do not create virtual env
source .venv/bin/activate
pip install -r requirements.txt
```

`uvicorn app:app --reload`
Runs the app in development mode.
The api server will listen in the default port 8000:
```
INFO:     Will watch for changes in these directories: ['your-directory/my-api']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [17234] using statreload
INFO:     Started server process [17236]
INFO:     Waiting for application startup.
INFO:     ASGI 'lifespan' protocol appears unsupported.
INFO:     Application startup complete.
```
