# Makefile for PredictiveCustomerEngine

.PHONY: help install data pipeline dashboard test clean lint format

VENV = venv
PYTHON = $(VENV)/bin/python3
PIP = $(VENV)/bin/pip

### Target Definitions ###

help:  ## Show this help
    @awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

venv:  ## Create Python virtual environment
    python3 -m venv $(VENV)
    $(PIP) install --upgrade pip

install: venv  ## Install dependencies
    $(PIP) install -r requirements.txt
    $(PIP) install -e .

data: venv  ## Generate sample data (6 months)
    $(PYTHON) data_generator/generate_dummy_data.py --init

pipeline: venv  ## Run full processing pipeline
    $(PYTHON) scripts/ingestion/fetch_data.py
    $(PYTHON) scripts/processing/clean_data.py
    $(PYTHON) scripts/training/train_model.py --model-type churn
    $(PYTHON) scripts/training/train_model.py --model-type clv
    $(PYTHON) scripts/evaluation/generate_metrics.py

dashboard: venv  ## Launch Streamlit dashboard
    $(VENV)/bin/streamlit run dashboards/main.py

test: venv  ## Run unit tests
    $(PYTHON) -m pytest tests/ -v

clean:  ## Remove generated files
    rm -rf data/raw/*.csv
    rm -rf data/processed/*.parquet
    rm -rf logs/*
    rm -rf $(VENV)

lint: venv  ## Check code quality
    $(VENV)/bin/flake8 --exclude=venv,data,trained_models
    $(VENV)/bin/mypy --ignore-missing-imports .

format: venv  ## Auto-format code
    $(VENV)/bin/black .
    $(VENV)/bin/isort .
