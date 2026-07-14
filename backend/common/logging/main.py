import json
import logging.config
import os
from pathlib import Path
from typing import Any


config_path = Path(__file__).parent / "config.json"

def get_logging_config(config_path: Path):
    config: Any 
    if config_path.exists():
        with open(config_path, "r") as f:
            config = json.load(f)
            
    return config

def setup_logging():
    """Sets up logging configuration."""

    logging.config.dictConfig(get_logging_config(config_path=config_path))

    # else:
    #     # Fallback to basic config if JSON is missing
    #     logging.basicConfig(level=logging.INFO)
    #     logging.warning("logging_config.json not found. Falling back to basicConfig.")
