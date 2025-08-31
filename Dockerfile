FROM python:3.11-slim

WORKDIR /app

# Install only essential system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install with wheel cache
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --find-links https://download.pytorch.org/whl/cpu/torch_stable.html \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir -r requirements.txt

# Clean up build dependencies to reduce image size
RUN apt-get purge -y gcc && apt-get autoremove -y

# Copy application code
COPY . .

# Expose port  
EXPOSE $PORT

# Start command
CMD python -m uvicorn main:app --host 0.0.0.0 --port $PORT