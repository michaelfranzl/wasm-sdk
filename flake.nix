{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      package = import ./default.nix pkgs;
    in
    {
      packages.x86_64-linux.default = package;
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;
    };
}
