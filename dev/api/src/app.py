from flask import Flask, jsonify, request, render_template, redirect, url_for
from .db import Connector
import datetime
import json
import os

app = Flask(__name__)
db = Connector()

# Initialize database
db.execute("CREATE TABLE IF NOT EXISTS Stuff(Id SERIAL PRIMARY KEY, Name VARCHAR(100) NOT NULL, Created TIMESTAMP NOT NULL DEFAULT (current_timestamp AT TIME ZONE 'UTC-3'));")
db.execute(f"INSERT INTO stuff(Name) VALUES ('{os.getenv('HOSTNAME', 'sem_host')}');")

@app.route('/')
def homepage():
    return dump_table('stuff')

def dump_table(table):
    # Get table data
    data = db.query(f'SELECT * FROM {table}')
    print(data)
    # Return data as JSON
    return jsonify(data)
