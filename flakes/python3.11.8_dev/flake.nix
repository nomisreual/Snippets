{
  description = "Python 3.11.8 and Poetry";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default =
      pkgs.mkShell {
        buildInputs = [
          pkgs.python311
          pkgs.poetry
        ];
        shellHook = ''
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

        '';
      };

  };
}

