import json
import logging.config
import os
from pathlib import Path

def setup_logging():
    """Sets up the centralized logging configuration."""
    config_path = Path(__file__).parent / "logging_config.json"
    
    if config_path.exists():
        with open(config_path, "r") as f:
            config = json.load(f)
            logging.config.dictConfig(config)
    else:
        # Fallback to basic config if JSON is missing
        logging.basicConfig(level=logging.INFO)
        logging.warning("logging_config.json not found. Falling back to basicConfig.")
