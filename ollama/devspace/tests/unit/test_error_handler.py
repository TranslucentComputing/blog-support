"""
Unit tests for the Error Handler.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""

import pytest
from fastapi import FastAPI, HTTPException
from fastapi.testclient import TestClient
from src.prompts.exceptions.custom_exceptions import (
    CommandNotAllowedError,
    Error,
    ForbiddenError,
)
from src.prompts.exceptions.fastapi_error_handler import ErrorHandler


@pytest.fixture
def app() -> FastAPI:
    """
    Fixture to create a FastAPI application with routes that trigger various exceptions.

    Returns:
        FastAPI: The FastAPI application instance.
    """
    app = FastAPI()

    @app.get("/http_exception")
    async def http_exception_route():
        """
        Route that raises an HTTPException with status code 404.
        """
        raise HTTPException(status_code=404, detail="Not Found")

    @app.get("/custom_error")
    async def custom_error_route():
        """
        Route that raises a custom Error exception.
        """
        raise Error(description="Custom error occurred")

    @app.get("/forbidden_error")
    async def forbidden_error_route():
        """
        Route that raises a ForbiddenError exception.
        """
        raise ForbiddenError(description="Forbidden action")

    @app.get("/command_not_allowed_error")
    async def business_logic_error_route():
        """
        Route that raises a CommandNotAllowedError exception.
        """
        raise CommandNotAllowedError(description="Command Not Allowed")

    error_handler = ErrorHandler(app)
    error_handler.register_default_handlers()

    return app


@pytest.fixture
def client(app: FastAPI) -> TestClient:
    """
    Fixture to create a TestClient for the FastAPI application.

    Args:
        app (FastAPI): The FastAPI application instance.

    Returns:
        TestClient: The test client for the FastAPI application.
    """
    return TestClient(app)


def test_http_exception_handler(client: TestClient):
    """
    Test to verify the handling of HTTPException.

    Args:
        client (TestClient): The test client for the FastAPI application.
    """
    response = client.get("/http_exception")
    assert response.status_code == 404
    assert response.json() == {
        "code": 404,
        "name": "HTTPException",
        "description": "Not Found",
    }


def test_custom_error_handler(client: TestClient):
    """
    Test to verify the handling of custom Error exceptions.

    Args:
        client (TestClient): The test client for the FastAPI application.
    """
    response = client.get("/custom_error")
    assert response.status_code == 500
    assert response.json() == {
        "code": 500,
        "name": "Error",
        "description": "Custom error occurred",
    }


def test_forbidden_error_handler(client: TestClient):
    """
    Test to verify the handling of ForbiddenError exceptions.

    Args:
        client (TestClient): The test client for the FastAPI application.
    """
    response = client.get("/forbidden_error")
    assert response.status_code == 403
    assert response.json() == {
        "code": 403,
        "name": "ForbiddenError",
        "description": "Forbidden action",
    }


def test_command_not_allowed_error_handler(client: TestClient):
    """
    Test to verify the handling of CommandNotAllowedError exceptions.

    Args:
        client (TestClient): The test client for the FastAPI application.
    """
    response = client.get("/command_not_allowed_error")
    assert response.status_code == 403
    assert response.json() == {
        "code": 403,
        "name": "CommandNotAllowedError",
        "description": "Command Not Allowed",
    }
