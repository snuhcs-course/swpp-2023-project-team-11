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
# make sure you are using uvicorn installed in your virtual environment.
which uvicorn
# if it does not belong to your venv, deactivate and then activate venv
deactivate
source venv/bin/activate
```

## How to Test

```sh
SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} python -m unittest test
```

## How to Run

```sh
SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} uvicorn src.main:app --reload
```
