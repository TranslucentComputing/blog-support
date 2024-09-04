"""
Utility Module: JSON File Loader

This module provides a function to read JSON files and convert them to Python dictionaries.
Given the path to a JSON file, it returns the parsed content as a dictionary.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""

import json
from typing import Any, Dict

from ..exceptions.custom_exceptions import (
    JSONFileError,
    JSONFileNotFoundError,
    JSONInvalidEncodingError,
    JSONInvalidError,
)
from ..utils.logger import AppLogger


def load_json_file(filename: str) -> Dict[str, Any]:
    """
    Read a JSON file and load its data.

    Args:
        filename (str): The path to the JSON file.

    Returns:
        Dict[str, Any]: The parsed JSON data.

    Raises:
        JSONFileNotFoundError: If the file is not found.
        JSONInvalidError: If the file content is not valid JSON.
        JSONInvalidEncodingError: If the file encoding is not UTF-8.
        JSONFileError: For other unexpected errors.
    """
    try:
        with open(filename, "r", encoding="utf-8") as json_file:
            return json.load(json_file)
    except FileNotFoundError as fileexc:
        AppLogger.error(f"File not found: {filename}")
        raise JSONFileNotFoundError(filename) from fileexc
    except json.JSONDecodeError as jsonexc:
        AppLogger.error(f"Invalid JSON in file: {filename}. Error: {str(jsonexc)}")
        raise JSONInvalidError(filename, str(jsonexc)) from jsonexc
    except UnicodeDecodeError as uniexc:
        AppLogger.error(f"Invalid encoding in file: {filename}. Error: {str(uniexc)}")
        raise JSONInvalidEncodingError(filename, str(uniexc)) from uniexc
    except Exception as exc:
        AppLogger.error(f"Unexpected error while reading '{filename}': {str(exc)}")
        raise JSONFileError(
            "Unexpected error while reading '%s': %s", filename, str(exc)
        ) from exc
