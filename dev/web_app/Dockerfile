FROM python:3.9.16-alpine3.17

# Copy files and change working directory to /app
COPY src /app
WORKDIR /app

# Install requirements
RUN pip install -r requirements.txt

# Run Flask server
CMD flask run --host=0.0.0.0

EXPOSE 5000
