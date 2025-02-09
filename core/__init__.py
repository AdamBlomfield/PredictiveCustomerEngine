import logging
import logging.config
import yaml
import os

def setup_logging():
    """Initialize logging from YAML config"""
    config_path = os.path.join(os.path.dirname(__file__), 'logging.yaml')
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f.read())
        logging.config.dictConfig(config)

# Initialize when package is imported
setup_logging()
