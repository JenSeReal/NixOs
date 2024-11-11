let
  jpl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkg74RJ3yqoTG0rCs3rHarynEYr4JdhcFVejwZmY4hl jens.plueddemann@novatec-gmbh.de";
  # users = [ jfp ];

  macOS = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
in
# systems = [ macOS ];
{
  "homes/aarch64-darwin/jpl@NB230305JPL/secrets/ssh-config-jfp-one.age".publicKeys = [
    jpl
    macOS
  ];
}
