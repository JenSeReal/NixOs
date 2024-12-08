{
  pkgs,
  stdenv,
  lib,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
}:

stdenv.mkDerivation {
  pname = "universal-pidff";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "JacKeTUs";
    repo = "universal-pidff";
    rev = "main";
    hash = "sha256-BViobWl+9ypTcQJWtZ9pbeU4cmHcFNZWlsmQUOO64Vc=";
  };

  postPatch = ''
    sed -i 's|depmod|#depmod|' Makefile
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  installTargets = [ "install" ];

  meta = {
    description = "PIDFF driver with useful patches for initialization of FFB devices";
    homepage = "https://github.com/JacKeTUs/universal-pidff";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      computerdane
      racci
    ];
    platforms = lib.platforms.linux;
  };
}
