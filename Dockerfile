FROM ghcr.io/astral-sh/uv:python3.13-alpine

LABEL maintainers="mugambi645developer.com"

ENV PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_PROJECT_ENVIRONMENT=/opt/venv

WORKDIR /app

COPY pyproject.toml uv.lock* ./
RUN uv venv /opt/venv && \
    uv sync --frozen --all-groups --no-install-project

COPY . .
RUN uv sync --frozen --all-groups

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]