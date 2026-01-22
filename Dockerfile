# 1. Use lightweight Python image
FROM python:3.12-slim

# 2. Set working directory inside container
WORKDIR /app

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*


# 3. Copy dependency file first (layer caching)
COPY app/requirements.txt .

# 4. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy application code
COPY app/ .

# 6. Expose Flask port
EXPOSE 5000

# 7. 🔍 Health check: app must respond on /
HEALTHCHECK --interval=10s --timeout=3s --retries=5 \
  CMD curl -f http://localhost:5000 || exit 1

# 8. Run the Flask app
CMD ["python", "app.py"]

