from flask import Flask, jsonify, request, render_template, redirect, url_for
from .db import Connector
import datetime
import json
import os

app = Flask(__name__)
db = Connector()


@app.route('/')
def homepage():
    return dump_table('stuff')

def dump_table(table):
    # Get table data
    data = db.query(f'SELECT * FROM {table}')
    print(data)
    # Return data as JSON
    return jsonify(data)
