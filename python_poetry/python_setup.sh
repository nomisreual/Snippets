#!/usr/bin/env bash

echo "Setting everything up..."
echo ""

# Deleting commonly used virtual environment names
rm -rf env
rm -rf venv
rm -rf .venv
rm -rf .env

poetry config virtualenvs.in-project true

# Init poetry if it isn't already:
if [ -f pyproject.toml ]; then
  echo "Poetry already initialized."
  echo ""
else
  echo "Initializing poetry..."
  echo ""
    poetry init -n
  echo "Poetry initialized."
  echo ""
fi


# Get the Python version string
python_version_output=$(python --version 2>&1)

# Extract the version number using awk
version=$(awk '{print $2}' <<< "$python_version_output")

# Extract major and minor version parts
major_minor=$(cut -d '.' -f 1,2 <<< "$version")

# Form the desired version string
python_version="^$major_minor"

sed -i "s/python = \".*\"/python = \"$python_version\"/g" pyproject.toml

# Copy over the configuration files:
echo "Copying over configuration files..."
echo ""

# Flake8
if [ -f ./.flake8 ]; then
  echo ".flake8 already exists."
  echo ""
else
  echo "Copying .flake8..."
  echo ""
  cp ${./.flake8} ./.flake8
fi

# Pre-commit-config
PRECOMMIT="pre-commit-config.yaml"

if [ -f "$PRECOMMIT" ] || [ -f ".$PRECOMMIT" ]; then
  echo "A pre-commit config file already exists."
  echo ""
else
  echo "Copying .pre-commit-config.yaml..."
  echo ""
  cp ${./.pre-commit-config.yaml} ./.pre-commit-config.yaml
fi

# Gitignore
if [ -f ./.gitignore ]; then
  echo ".gitignore already exists."
  echo ""
else
  echo "Copying .gitignore..."
  echo ""
  cp ${./.gitignore} ./.gitignore
fi

# Add test dependencies:
poetry add pytest pytest-cov --group test 2>/dev/null

# Add development dependencies:
poetry add flake8 black pre-commit --group development

# Check for .git, init if not present.
if [ -d ./.git ]; then
  echo "Already a GIT repository."
  echo ""
else
  git init
fi

poetry run pre-commit install
poetry run pre-commit install --hook-type commit-msg

if [ -f README.md ]; then
  echo "README.md already exists."
  echo ""
else
  echo "Creating README.md..."
  echo ""
  touch README.md
fi

echo "All set! You are good to go. Enjoy your journey!"
