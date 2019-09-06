{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [libxml2];
}
