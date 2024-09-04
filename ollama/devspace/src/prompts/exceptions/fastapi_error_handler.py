"""
ErrorHandler module.

Handles HTTP and custom exceptions using FastAPI's exception handler mechanism.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""

from typing import Type, Union

from fastapi import FastAPI, HTTPException
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.types import HTTPExceptionHandler

from ..utils.logger import AppLogger
from .custom_exceptions import CommandNotAllowedError, Error, ForbiddenError


class CustomJSONResponse(JSONResponse):
    """Custom JSONResponse class."""

    def __init__(self, status_code: int, name: str, description: str) -> None:
        """
        Initialize CustomJSONResponse instance.

        Args:
            status_code (int): HTTP status code of the response.
            name (str): Name of the error.
            description (str): Description of the error.
        """
        # Validate status_code
        if status_code < 100 or status_code >= 600:
            status_code = 500

        content = {"code": status_code, "name": name, "description": description}
        super().__init__(status_code=status_code, content=content)


class ErrorHandler:
    """
    ErrorHandler class to manage HTTP and custom exceptions.

    Attributes:
        app (FastAPI): The FastAPI application instance.

    Methods:
        _error_handler(request, exc): Handle all exceptions.
        add_exception_handler(exception, handler): Register an exception handler to the FastAPI app.
        register_default_handlers(): Register default exception handlers for the app.
    """

    def __init__(self, app: FastAPI):
        """
        Initialize ErrorHandler instance.

        Args:
            app (FastAPI): The FastAPI application instance.
        """
        self.app = app

    async def _error_handler(self, request: Request, exc: Exception) -> JSONResponse:
        """
        Handle all exceptions.

        Args:
            request (Request): The request that caused the exception.
            exc (Exception): The raised exception instance.

        Returns:
            JSONResponse: A formatted JSON response with error details.
        """
        # Retrieve request id for logging
        request_id = getattr(request.state, "request_id", None)

        description = getattr(exc, "description", "An unexpected error occurred.")
        status_code = getattr(exc, "status_code", 500)

        # Handle HTTPException specifically to get the correct status code and detail
        if isinstance(exc, HTTPException):
            status_code = exc.status_code
            description = exc.detail

        if request_id:
            description = f"[Request Id: {request_id}], {description}"

        AppLogger.error(f"Error handler: {description}")
        return CustomJSONResponse(
            status_code=status_code, name=type(exc).__name__, description=description
        )

    def add_exception_handler(
        self,
        exception: Union[int, Type[Exception]],
        handler: HTTPExceptionHandler,
    ) -> None:
        """
        Register an exception handler to the FastAPI app.

        Args:
            exception (Union[int, Type[Exception]]): The exception type to handle.
            handler (HTTPExceptionHandler): The function to execute when the exception occurs.
        """
        self.app.add_exception_handler(exception, handler)

    def register_default_handlers(self) -> None:
        """
        Register default exception handlers for the app.
        """
        self.add_exception_handler(Exception, self._error_handler)
        self.add_exception_handler(Error, self._error_handler)
        self.add_exception_handler(HTTPException, self._error_handler)
        self.add_exception_handler(ForbiddenError, self._error_handler)
        self.add_exception_handler(CommandNotAllowedError, self._error_handler)
