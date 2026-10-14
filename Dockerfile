FROM python:3.13-slim

LABEL maintainers="mugambi645developer.com"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/opt/venv

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY pyproject.toml README.md ./
RUN uv venv /opt/venv && \
    uv sync --no-install-project --no-dev --python /opt/venv/bin/python || \
    uv sync --no-dev --python /opt/venv/bin/python

COPY . .

RUN uv sync --no-dev --python /opt/venv/bin/python

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8000

CMD ["python", "main.py"]