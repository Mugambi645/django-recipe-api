FROM ghcr.io/astral-sh/uv:python3.13-alpine

LABEL maintainers="mugambi645developer.com"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a virtual environment outside /app to protect it from volume overwrites
RUN uv venv /py
ENV VIRTUAL_ENV=/py
ENV PATH="/py/bin:$PATH"

# Copy dependency specifications
COPY pyproject.toml uv.lock* /app/

# Install dependencies using uv (handles pyproject.toml natively)
RUN uv sync --frozen --no-install-project || uv sync --no-install-project

# Copy the rest of the application code
COPY . /app

# Create a non-root user and set permissions
RUN adduser -D django-user && \
    chown -R django-user:django-user /app && \
    chown -R django-user:django-user /py

USER django-user

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]