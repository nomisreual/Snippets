# Simple nix-shell for running python with poetry:

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python311
    pkgs.poetry
  ];
  shellHook = ''

  echo "Hello dear friend, you are about to start an amazing journey..."

  poetry config virtualenvs.in-project true
  if [ -f pyproject.toml ]; then
    echo "Poetry already initialized."
  else
    poetry init -n
  fi

  # Deleting commonly used virtual environment names
  rm -rf env
  rm -rf venv
  rm -rf .venv
  rm -rf .env
  
  poetry add pytest pytest-cov --group test
  poetry add flake8 black pre-commit --group development

  poetry install --no-root
  # Check for .git, init if not present.
  if [ -d ./.git ]; then
    echo "Already a GIT repository."
  else
    git init
  fi

  # Check for pre-commit-config, create if not present:
  FILE="pre-commit-config.yaml"

  if [ -f "$FILE" ]
  then
    echo "Pre-commit configuration exists already."
  else
    echo "Creating the pre-commit-config.yaml..."
    echo "repos:" >> pre-commit-config.yaml
    echo "    - repo: https://github.com/pycqa/flake8.git" >> pre-commit-config.yaml
    echo "      rev: 3.9.2" >> pre-commit-config.yaml 
    echo "      hooks:" >> pre-commit-config.yaml
    echo "        - id: flake8" >> pre-commit-config.yaml
    echo "          exclude: ^venv/|^env/|.*test.*" >> pre-commit-config.yaml
  fi

  poetry run pre-commit install

  echo "All set! You are good to go. Enjoy your journey!"
  '';
}