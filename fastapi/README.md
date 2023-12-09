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
SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} python -m unittest tests/*.py
# To test with coverage, install coverage dependency.
pip install coverage
coverage run -m unittest --verbose tests/*.py
coverage report
```

## How to Run

```sh
SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} uvicorn src.main:app --reload
```

## How to Deploy

Requires docker on the environment.
Setup required environments in `deploy.conf`.

```sh
sudo chmod 744 ops/deploy.sh
ops/deploy.sh
```

## How to Cleanup

Requires docker on the environment.

```sh
sudo chmod 744 ops/cleanup.sh
ops/cleanup.sh
```
