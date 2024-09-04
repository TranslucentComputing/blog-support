"""
Test Suite for FastAPI Application

This test suite is designed to validate the functionality and configuration of the FastAPI application
created by the `create_app` factory function. The tests cover the following areas:
- Proper setting and configuration of application settings and logging.
- Functionality of core endpoints such as `/healthcheck`, `/`, and `/endpoints/`.
- Middleware integration, including CORS, timeout, and request ID middleware.
- Custom logging filters and error handling.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""

import logging

import pytest
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.testclient import TestClient
from src.prompts import create_app
from starlette.middleware import Middleware


@pytest.fixture
def app() -> FastAPI:
    """Create and return a FastAPI application instance."""
    return create_app()


@pytest.fixture
def client(app: FastAPI) -> TestClient:
    """Create and return a test client for the FastAPI"""
    return TestClient(app)


def test_setup_settings(app: FastAPI):
    """Test if settings are correctly set."""
    assert hasattr(app.state, "settings")
    assert app.state.settings is not None


def test_logger_configurations(app: FastAPI):
    """Test if the logger configurations are set correctly."""
    app_logger = logging.getLogger("app")

    # Checking if the levels are set correctly
    log_level = app.state.settings.app_log_level.upper()
    assert app_logger.level == getattr(logging, log_level)

    # Check the handlers for the loggers
    assert len(app_logger.handlers) > 0


def test_healthcheck_endpoint(client: TestClient):
    """Test the healthcheck endpoint."""
    response = client.get("/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"status": "Healthy"}


def test_root_endpoint(client: TestClient):
    """Test the default root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert "Welcome to the Kubert Agent FastAPI service!" in response.text


def test_cors_middleware(app: FastAPI):
    """Test if CORS middleware is applied correctly."""
    cors_middleware_applied = any(
        isinstance(middleware, Middleware) and middleware.cls is CORSMiddleware
        for middleware in app.user_middleware
    )
    assert cors_middleware_applied is True


def test_timeout_middleware(app: FastAPI):
    """Test if TimeoutMiddleware is applied correctly."""
    middleware_names = [middleware.cls.__name__ for middleware in app.user_middleware]
    assert "TimeoutMiddleware" in middleware_names


def test_request_id_middleware(app: FastAPI):
    """Test if RequestIDMiddleware is applied correctly."""
    middleware_names = [middleware.cls.__name__ for middleware in app.user_middleware]
    assert "RequestIDMiddleware" in middleware_names


def test_endpoints_route(client: TestClient):
    """Test the /endpoints route to list all available routes."""
    response = client.get("/endpoints/")
    assert response.status_code == 200
    json_data = response.json()

    # Check if there are expected routes in the returned data
    assert isinstance(json_data, dict)
    assert "endpoints" in json_data
    endpoints_list = json_data["endpoints"]
    assert any(endpoint["path"] == "/healthcheck" for endpoint in endpoints_list)
    assert any(endpoint["path"] == "/" for endpoint in endpoints_list)


def test_logging_filter(app: FastAPI):
    """Test if logging filter is applied to the uvicorn.access logger."""
    uvicorn_access_logger = logging.getLogger("uvicorn.access")
    filters = [type(f).__name__ for f in uvicorn_access_logger.filters]
    assert "SuppressSpecificLogEntries" in filters
