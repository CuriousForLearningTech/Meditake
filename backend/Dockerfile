FROM python:3.14-rc-slim

WORKDIR /app

# Install uv
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Copy the rest of the application
COPY . .

# Set python path
ENV PYTHONPATH=/app

# Default command (can be overridden by docker-compose)
CMD ["uv", "run", "python", "-m", "services.api"]
