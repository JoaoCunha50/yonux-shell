{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      customQmlls = pkgs.writeShellScriptBin "qmlls" ''
        exec ${pkgs.kdePackages.qtdeclarative}/bin/qmlls \
          -I "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml" \
          -I "${pkgs.quickshell}/lib/qt-6/qml" \
          "$@"
      '';
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          quickshell
          kdePackages.qtdeclarative
          kdePackages.qtwayland
          gammaray
          customQmlls
        ];

        shellHook = ''
          export PATH="${customQmlls}/bin:$PATH"
        '';
      };
    };
}
