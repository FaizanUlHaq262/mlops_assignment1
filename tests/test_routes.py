import pytest
import sys
import os
# Add the parent directory to the system path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))


from Flask_app import app


def test_home():
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b'Afnaan' in response.data


def test_hello():
    with app.test_client() as client:
        response = client.get('/hello')
        assert response.status_code == 200
        assert b'Hello, TO MLOPS!' in response.data
