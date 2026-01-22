# 1. Use lightweight Python image
FROM python:3.12-slim

# 2. Set working directory inside container
WORKDIR /app

# 3. Copy dependency file first (layer caching)
COPY app/requirements.txt .

# 4. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy application code
COPY app/ .

# 6. Expose Flask port
EXPOSE 5000

# 7. Run the Flask app
CMD ["python", "app.py"]

