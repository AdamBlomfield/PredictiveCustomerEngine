#!/usr/bin/env python3
import argparse
from core import get_logger

logger = get_logger(__name__)

def main(model_type: str, retrain: bool = False):
    """Main training entrypoint"""
    logger.info(f"Starting {model_type} training")
    # Training logic here

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-type", choices=["churn", "clv"], required=True)
    parser.add_argument("--retrain", action="store_true")
    args = parser.parse_args()
    
    main(args.model_type, args.retrain)
