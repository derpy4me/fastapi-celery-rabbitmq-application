FROM python:3.10-bullseye

RUN apt update && apt install -y supervisor
RUN mkdir -p /var/log/supervisor /var/log/celery /var/log/fastapi /db/ /var/log/flower

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python3 - && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    /etc/poetry/bin/poetry config virtualenvs.create false

COPY ./pyproject.toml /app/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /app

RUN /etc/poetry/bin/poetry install --no-root --no-dev

COPY . .

CMD ["/usr/bin/supervisord"]