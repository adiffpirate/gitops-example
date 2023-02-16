from flask import Flask, render_template, request
import requests
import json
import os

API_ADDR = f'http://{os.getenv("API_HOST")}:{os.getenv("API_PORT")}'

app = Flask(__name__)

def call_api(endpoint='/'):
    return requests.get(f'{API_ADDR}{endpoint}').json()

@app.route('/')
def homepage():
    return render_template('homepage.html')

@app.route('/database/')
def database():
    data = call_api()
    print(data)
    return render_template('homepage.html', data=data)

@app.route('/envvars/')
def envvars():
    data = []
    for key, value in os.environ.items():
        if 'PYTHON' in key:
            data.append([key, value])
    return render_template('homepage.html', data=data)
