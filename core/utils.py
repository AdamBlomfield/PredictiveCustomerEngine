from pathlib import Path
import yaml
from typing import Dict

def load_config(config_name: str) -> Dict:
    """Load YAML config from config/ directory"""
    config_path = Path(__file__).parent.parent / "config" / f"{config_name}.yaml"
    with open(config_path) as f:
        return yaml.safe_load(f)

def get_data_path(key: str) -> Path:
    """Get filesystem path from paths.yaml"""
    paths = load_config("paths")
    return Path(paths[key])
