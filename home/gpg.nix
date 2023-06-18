{ pkgs, ... }: {
  programs.gpg = {
    enable = true;

    settings = {
      default-key = "0x0ADE9C5EE5A17908";
      trusted-key = "0x0ADE9C5EE5A17908";

      no-greeting = true;
      throw-keyids = true;
    };

    scdaemonSettings = {
      disable-ccid = true;
      reader-port = "Yubico Yubi";
    };

    publicKeys = [
      {
        source = ./keys/yubikey.asc;
        trust = 5;
      }
    ];
  };

  home.packages = with pkgs; [
    # Tools for backing up keys.
    paperkey
    pgpdump
    cryptsetup

    # Securely accept passphrases.
    pinentry-qt
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryFlavor = "qt";
  };
}
