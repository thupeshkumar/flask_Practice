"""
Basic pytest smoke tests for the Flask Student Registration app.
Place this file at the repository root or inside a tests/ folder
(update the import below to match wherever app.py actually lives).

These tests avoid requiring a real MongoDB connection so they can run
safely inside CI. If app.py connects to MongoDB at import time, mock
that connection or gate it behind an environment variable
(e.g. TESTING=1) before importing.
"""

import os
import pytest

os.environ["TESTING"] = "1"

from app import app as flask_app  # noqa: E402


@pytest.fixture
def client():
    flask_app.config.update({"TESTING": True})
    with flask_app.test_client() as client:
        yield client


def test_app_exists():
    assert flask_app is not None


def test_home_page_loads(client):
    response = client.get("/")
    # Accept 200 (rendered) or 302 (redirect, e.g. to a login/index route)
    assert response.status_code in (200, 302)


def test_404_for_unknown_route(client):
    response = client.get("/this-route-does-not-exist")
    assert response.status_code == 404
