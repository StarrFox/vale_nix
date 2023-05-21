## Configuration for user accounts on NixOS systems.
{ ... }:
  let
    publicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9cKM/d2D1NxvY+C1rO6Ia6Z4hS8a52GJiQo1y2v+BO"
    ];

  in {
    users.users = {
      vale = {
        isNormalUser = true;
        home = "/home/vale";
        extraGroups = [
          "wheel"
          "storage"
          "networkmanager"
        ];
        openssh.authorizedKeys.keys = publicKeys;
      };
    };

    boot.initrd.network.ssh.authorizedKeys = publicKeys;
  }