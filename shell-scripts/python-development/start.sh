#!/bin/bash

echo "Setting you up..."

# Deleting commonly used virtual environment names
rm -rf env
rm -rf venv
rm -rf .venv
rm -rf .env

# Virtual environment inside the project root:
poetry config virtualenvs.in-project true

# Init poetry if it isn't already:
if [ -f pyproject.toml ]; then
  echo "Poetry already initialized."
else
  poetry init -n
fi

# Create venv manually:
python -m venv .venv
poetry env use ./.venv/bin/python

# Add test dependencies:
poetry add pytest pytest-cov --group test

# Add development dependencies:
poetry add flake8 black pre-commit --group development

poetry install --no-root

# Check for .git, init if not present.
if [ -d ./.git ]; then
  echo "Already a GIT repository."
else
  git init
fi

poetry run pre-commit install
poetry run pre-commit install --hook-type commit-msg

echo "All set! You are good to go. Enjoy your journey!"
