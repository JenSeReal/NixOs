{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "layan-cursors";
  version = "2021-08-01";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "Izc5Q3IuM0ryTIdL+GjhRT7JKbznyxS2Fc4pY5dksq4=";
  };

  installPhase = ''
    install -dm 755 $out/share/icons
    mv dist $out/share/icons/layan-cursors
    mv dist-border $out/share/icons/layan-border-cursors
    mv dist-white $out/share/icons/layan-white-cursors
  '';

  meta = with lib; {
    description = "Layan cursor theme";
    homepage = "https://github.com/vinceliuice/Layan-cursors";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ JenSeReal ];
  };
}
