FROM python:3.11-slim

WORKDIR /app

# Install only essential system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Clean up build dependencies to reduce image size
RUN apt-get purge -y gcc && apt-get autoremove -y

# Copy application code
COPY . .

# Expose port  
EXPOSE $PORT

# Start command
CMD ["python", "main.py"]