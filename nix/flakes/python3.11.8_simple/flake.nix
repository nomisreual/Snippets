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
        '';
      };

  };
}

