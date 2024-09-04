"""
Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.

Description:
Custom exception classes for the project.
"""

from typing import Any, Optional


class Error(Exception):
    """Base class for other exceptions"""

    status_code: int = 500
    description: str = "An unexpected error occurred."

    def __init__(self, *args: object, description: Optional[str] = None) -> None:
        """
        Initialize Error instance.

        Allows for a custom description that describes the error.

        Args:
            *args: Variable length argument list.
            description: An optional custom description of the error.
        """
        super().__init__(*args)
        if description:
            self.description = description


class BusinessLogicError(Error):
    """Base class for exceptions in business logic."""

    status_code = 400
    description = "A business logic error occurred."


class JSONFileError(Exception):
    """Base exception for errors related to reading JSON files."""

    def __init__(self, message_format: str, *args: Any):
        """
        Initialize JSONFileError instance.

        Args:
            message_format (str): The message format string.
            *args: Arguments to be formatted into the message.
        """
        message = message_format % args
        super().__init__(message)


class JSONFileNotFoundError(JSONFileError):
    """Raised when the JSON file is not found."""

    def __init__(self, filename: str):
        """
        Initialize JSONFileNotFoundError instance.

        Args:
            filename (str): The name of the JSON file that was not found.
        """
        super().__init__("JSON File '%s' not found.", filename)


class JSONInvalidError(JSONFileError):
    """Raised when the JSON file is invalid."""

    def __init__(self, filename: str, error: str):
        """
        Initialize JSONInvalidError instance.

        Args:
            filename (str): The name of the invalid JSON file.
            error (str): The error message describing why the JSON is invalid.
        """
        super().__init__(
            "JSON File '%s' is not a valid JSON. Error: %s", filename, error
        )


class JSONInvalidEncodingError(JSONFileError):
    """Raised when the file encoding is not UTF-8."""

    def __init__(self, filename: str, error: str):
        """
        Initialize JSONInvalidEncodingError instance.

        Args:
            filename (str): The name of the JSON file with invalid encoding.
            error (str): The error message describing the encoding issue.
        """
        super().__init__(
            "JSON File '%s' does not use valid utf-8 encoding. Error: %s",
            filename,
            error,
        )


class CommandExecutionError(BusinessLogicError):
    """Custom exception for command execution errors."""


class ForbiddenError(Error):
    """Exception raised for forbidden actions due to insufficient roles."""

    status_code = 403
    description = "Forbidden: insufficient roles"


class CommandNotAllowedError(Error):
    """Exception raised for business logic constraints that forbid an action."""

    status_code = 403
    description = "Command Not Allowed"
