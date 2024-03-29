# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../modules/nix/printing.nix
      ./../../modules/nix/sddm.nix
      ./../../modules/nix/thunar.nix
      ./../../modules/nix/udev.nix
      ./../../modules/nix/nm-applet.nix
      ./../../modules/nix/alvr.nix
      ./../../modules/nix/docker.nix
      ./../../modules/nix/samba.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Cyclone"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable nix-command and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gfernandez = {
    isNormalUser = true;
    description = "Gabriel Fernandez";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "podman" ];
    packages = with pkgs; [];
  };

  # Define a default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gfernandez" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    libnotify
    brave
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    networkmanagerapplet
    wl-clipboard
    pavucontrol
    neofetch
    ripgrep
    curl
    dropbox-cli
    catppuccin-sddm-corners
    libsForQt5.qt5.qtgraphicaleffects
    unzip
    gnome.file-roller
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    haskellPackages.freetype2
    libgsf
    nufraw-thumbnailer
    gnome-epub-thumbnailer
    mcomix
    f3d
    cava
    parted
    btop
    wine
    wine64
    openmw
    aria
    zulu11
    zulu8
    zulu17
    dotnetCorePackages.sdk_6_0
    # omnisharp-roslyn
    mono

    # Cyclone only
    quickemu
    spice
    spice-gtk
    spice-vdagent
  ];

  # Steam specific config
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    rPackages.fontawesome
    nerdfonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 17500 25565 ]; 
  networking.firewall.allowedUDPPorts = [ 17500 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Dropbox Setup
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enabling Hyprland on NixOS
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint eletron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    # Opengl
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    # Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };  

  services.blueman.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Install necessary virtualisation packages
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # swaylock fix
  security.pam.services.swaylock = {};

  # required for vinegar
  services.flatpak.enable = true;
}
