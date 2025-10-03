{
  description = "Python environment with ML packages and Jupyter kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          numpy
          tqdm
          pillow
          torch
          torchvision
          ultralytics-thop
          matplotlib
          scikit-learn
          torchinfo
          jupyter
          ipywidgets
          ipykernel
        ]);
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];
          
          shellHook = ''
            # Create a temporary directory for the kernel spec
            export JUPYTER_DATA_DIR=$PWD/.jupyter
            
            # Install the kernel spec
            python -m ipykernel install --user --name=ml-env --display-name="Python (ML Environment)"
            
            echo "Python environment with ML packages is ready!"
            echo "To start Jupyter: jupyter notebook"
            echo "To start JupyterLab: jupyter lab"
            echo ""
            echo "The kernel 'Python (ML Environment)' is now available in Jupyter."
          '';
        };
        
        packages.default = pythonEnv;
      }
    );
}