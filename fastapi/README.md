# To Setup on Your Local Environment

You need PostgreSQL to be installed to run the server on your local machine.
NOTE: Deployment process will use PostgreSQL docker image

## PostgreSQL

```sh
sudo apt install postgresql # Linux
brew install postgresql@14 # MacOS
```

## Python Environment Setup

```sh
virtualenv venv --python=3.11 # 3.10+
source venv/bin/activate
pip install -r requirements.txt
# make sure you are using uvicorn installed in your virtual environment.
which uvicorn
# if it does not belong to your venv, deactivate and then activate venv
deactivate
source venv/bin/activate
```

## How to Run Unit Tests

```sh
SNEK_POSTGRES_HOST=localhost SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} python -m unittest tests/*.py
# To test with coverage, install coverage dependency.
pip install coverage
coverage run -m unittest --verbose tests/*.py
coverage report
```

## How to Run Server

```sh
SNEK_POSTGRES_HOST=localhost SNEK_POSTGRES_DB={DBNAME} SNEK_POSTGRES_USER={USER} SNEK_POSTGRES_PW={PW} uvicorn src.main:app --reload
```

# To Deploy on Production Environment (or Local Environment for IT-Test Purpose)

## How to Deploy

Requires docker on the environment.
Setup required environments in `deploy.conf`.

If something goes wrong, install PostgreSQL on your local machine.
Then remove `docker run` for `snek-db` container in `ops/deploy.sh`.
Make sure your `deploy.conf` is up to date.

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
