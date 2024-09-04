"""
This module provides a Pydantic-based settings configuration.

It reads the configuration values from environment variables,
with a fallback to a `.env` file.

Author: Patryk Golabek
Company: Translucent Computing Inc.
Copyright: 2024 Translucent Computing Inc.
"""
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Configuration settings. Set defaults that are overridden by the .env file."""

    host: str = "0.0.0.0"
    port: int = 3000

    server_log_level: str = "info"
    app_log_level: str = "debug"
    logging_path: str = "logging.json"

    ollama_model: str = "llama3.1:8b"
    ollama_url: str = "http://ollama.kubert-assistant.svc.cluster.local:11434"

    model_config = SettingsConfigDict(env_file=".env")
