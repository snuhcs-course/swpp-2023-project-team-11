FROM python:3.11

# Copy
COPY alembic alembic
COPY src src
COPY alembic.ini .
COPY requirements.txt .

# Install Requirements
RUN pip install -r requirements.txt
