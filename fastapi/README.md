## PostgreSQL

Required for testing

```sh
sudo apt install postgresql
brew install postgresql@14
```

## Installation

```sh
virtualenv venv --python=3.11
source venv/bin/activate
pip install -r requirements.txt
pip install fastapi
```

## How to Test

```sh
SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} python -m unittest test
```

## How to Run

```sh
uvicorn src.app.main:app --reload
```
