# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy only necessary files first
COPY requirements.txt /app/

# Install dependencies efficiently
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app

# Expose port 5000 for Flask
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=Flask_app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=production

# Run the Flask app
CMD ["python", "Flask_app.py"]
