"""
This module provides a factory method to create and configure an instance of the FastAPI application,
complete with logging, routes, error handling, CORS, and middleware.

The application integrates the ChatOllama model for handling AI-based chat routes and is designed to
be flexible and extendable with additional functionality as needed.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""

import logging
import logging.config
from typing import Any, Dict, cast

from config import Settings
from fastapi import FastAPI, Request
from fastapi.encoders import jsonable_encoder
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, JSONResponse
from langchain_community.chat_models import ChatOllama
from langserve import add_routes

from .exceptions.fastapi_error_handler import ErrorHandler
from .utils.file_utils import load_json_file
from .utils.log_filter import SuppressSpecificLogEntries
from .utils.middleware import RequestIDMiddleware, TimeoutMiddleware


def setup_logging(fast_api: FastAPI):
    """
    Set up logging configurations for the FastAPI application.

    This function loads the logging configuration from a JSON file specified
    in the app settings and applies it to the application. It also configures
    the log level and sets up specific log filtering for certain endpoints.

    Args:
        fast_api (FastAPI): The FastAPI application instance.

    Raises:
        ValueError: If the logging configuration file path is invalid.
    """

    # Load the logging configuration from JSON file
    logging_config: Dict[str, Any] = cast(
        Dict[str, Any], load_json_file(fast_api.state.settings.logging_path)
    )

    # Apply the logging configuration
    logging.config.dictConfig(logging_config)

    # Set the log level
    app_logger = logging.getLogger("app")
    app_logger.setLevel(fast_api.state.settings.app_log_level.upper())

    # Add the filter to Uvicorn's access logger
    endpoints_to_suppress = ["/metrics"]
    uvicorn_access_logger = logging.getLogger("uvicorn.access")
    uvicorn_access_logger.addFilter(SuppressSpecificLogEntries(endpoints_to_suppress))


def setup_metrics(fast_api: FastAPI):
    """
    Set up Prometheus middleware for collecting metrics in the application.

    Currently, this function is a placeholder for future implementation.

    Args:
        fast_api (FastAPI): The FastAPI application instance.
    """
    pass


def setup_error_handlers(fast_api: FastAPI):
    """
    Configure the global error handlers for the application.

    This function registers custom error handlers to provide meaningful and
    user-friendly responses in case of exceptions during request processing.

    Args:
        fast_api (FastAPI): The FastAPI application instance.
    """
    error_handler = ErrorHandler(fast_api)
    error_handler.register_default_handlers()


def setup_routes(fast_api: FastAPI):
    """
    Define and register the general routes for the FastAPI application.

    This function adds basic routes such as a health check endpoint and a root endpoint,
    along with an endpoint for listing all routes available in the application.

    Args:
        fast_api (FastAPI): The FastAPI application instance.
    """

    @fast_api.get("/healthcheck")
    def health_check():
        """Endpoint for health checking the application."""
        return {"status": "Healthy"}

    @fast_api.get("/")
    def root():
        """Root endpoint that returns a welcome HTML page."""
        html_content = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Welcome</title>
            </head>
            <body>
                <h1>Welcome to the Kubert Agent FastAPI service!</h1>
            </body>
            </html>
            """
        return HTMLResponse(content=html_content)

    @fast_api.get("/endpoints/")
    def endpoints(request: Request):
        """
        Endpoint to list all available routes in the application.

        Args:
            request (Request): The incoming HTTP request.

        Returns:
            JSONResponse: A list of all routes available in the application.
        """
        endpoints = [
            {"path": route.path, "name": route.name} for route in request.app.routes
        ]

        # Use jsonable_encoder to ensure the data is properly serialized
        formatted_response = jsonable_encoder({"endpoints": endpoints})

        # Return the JSONResponse with the formatted data
        return JSONResponse(content=formatted_response)


def setup_route_integration(fast_api: FastAPI, settings: Settings):
    """
    Set up the integration of external services, such as AI models, with FastAPI routes.

    This function integrates the ChatOllama model and adds the related routes under the "/ollama" path.

    Args:
        fast_api (FastAPI): The FastAPI application instance.
        settings (Settings): The application settings that contain configuration details.
    """

    # Create a ChatOllama model instance
    model = ChatOllama(model=settings.ollama_model, base_url=settings.ollama_url)

    # Add routes for the ChatOllama model to the FastAPI app at the "/ollama" path
    add_routes(
        fast_api,
        model,
        path="/ollama",
    )


def create_app() -> FastAPI:
    """
    Factory method to create, configure, and return an instance of the FastAPI application.

    The method sets up the application with logging, error handling, routing, middleware,
    and external service integrations, ensuring the app is ready for deployment.

    Returns:
        FastAPI: The configured FastAPI application instance.
    """

    # Create the FastAPI application
    fast_api = FastAPI()

    # Set up the settings
    fast_api.state.settings = Settings()  # type: ignore

    # Configure the FastAPI application
    setup_logging(fast_api)
    setup_metrics(fast_api)
    setup_error_handlers(fast_api)
    setup_routes(fast_api)
    setup_route_integration(fast_api, fast_api.state.settings)

    # Add TimeoutMiddleware with a timeout of 300 seconds (5 minutes)
    fast_api.add_middleware(TimeoutMiddleware, timeout=300)

    # Add request Id middleware
    fast_api.add_middleware(RequestIDMiddleware)

    # Set all CORS enabled origins
    fast_api.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
        expose_headers=["*"],
    )

    return fast_api
