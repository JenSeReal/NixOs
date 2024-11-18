let
  jpl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkg74RJ3yqoTG0rCs3rHarynEYr4JdhcFVejwZmY4hl jens.plueddemann@novatec-gmbh.de";
  # users = [ jfp ];

  macOS = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPVo6IOkJESQ8TjRDptovl6IC1lxAjx3qPOJ2rm+LKuf root@NB230305JPL";
in
# systems = [ macOS ];
{
  "homes/aarch64-darwin/jpl@NB230305JPL/secrets/ssh-config-jfp-one.age".publicKeys = [
    jpl
    macOS
  ];
  "homes/aarch64-darwin/jpl@NB230305JPL/secrets/git-config-include-identity-mb.age".publicKeys = [
    jpl
    macOS
  ];
  "homes/aarch64-darwin/jpl@NB230305JPL/secrets/git-config-include-identity-nt.age".publicKeys = [
    jpl
    macOS
  ];
}
