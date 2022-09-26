FROM python:3.10-bullseye

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python3 - && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    /etc/poetry/bin/poetry config virtualenvs.create false

COPY ./pyproject.toml /app/

WORKDIR /app

RUN /etc/poetry/bin/poetry install --no-root --no-dev

COPY . .

CMD ["python", "main.py"]