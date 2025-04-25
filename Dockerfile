FROM python:3.12-slim

# Install Python dependencies
RUN pip install --no-cache-dir paho-mqtt pyserial

# Copy the vedirect package and script
COPY vedirect /app/vedirect
COPY examples/vedirect_mqtt.py /app/vedirect_mqtt.py
# Set working directory
WORKDIR /app

# Make the scripts executable
RUN chmod +x /app/vedirect_mqtt.py

# Command to run the script
ENTRYPOINT ["python3", "/app/vedirect_mqtt.py"]