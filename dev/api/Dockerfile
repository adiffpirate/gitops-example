FROM python:3.9.16-alpine3.17

# Copy files and change working directory to /app
COPY src /app
WORKDIR /app

# Install requirements (https://stackoverflow.com/q/46711990)
RUN apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps

# Run Flask server
CMD flask run --host=0.0.0.0

EXPOSE 5000
