{ lib, pkgs, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "kickoff";
  version = "v0.7.0";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = version;
    hash = "sha256-AolJXFolMEwoK3AtC93naphZetytzRl1yI10SP9Rnzo=";
  };

  cargoHash = "sha256-OEFCR/2zSVZhZqAp6n48UyIwplRXxKb9HENsVaLIKkM=";

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    fontconfig
    freetype
    libxkbcommon
    wayland
  ];

  meta = with lib; {
    description = "Minimalistic program launcher";
    homepage = "https://github.com/j0ru/kickoff";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.JenSeReal ];
  };
}
