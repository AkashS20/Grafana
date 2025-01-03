# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the required Python application files into the container
COPY delivery_metrics.py /app/
COPY requirements.txt /app/

# Install the required Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that your application will run on
EXPOSE 8000

# Command to run your Python application
CMD ["python", "delivery_metrics.py"]

