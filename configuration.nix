{ config, pkgs, noctalia-shell, ... }:
let
  noctaliaPkg = noctalia-shell.packages.x86_64-linux.default;
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  });
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    theme = ./grub-theme;
  };
  boot.plymouth = {
    enable = true;
    theme = "hexagon";
    themePackages = [ pkgs.adi1090x-plymouth-themes ];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.package = pkgs.kdePackages.sddm;
  services.xserver.displayManager.sddm.theme = "sddm-astronaut-theme";
  services.xserver.displayManager.sddm.extraPackages = with pkgs; [
    kdePackages.qtmultimedia
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern";
    XCURSOR_SIZE = "24";
  };

  services.xserver.xkb.layout = "us";
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.niri.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim wget neovim neofetch alacritty rofi opencode grim slurp brightnessctl
    git starship noctaliaPkg sddm-astronaut bibata-cursors
    gnumake gcc git-lfs cmatrix htop cowsay swaybg efibootmgr
  ];

  system.stateVersion = "25.11";
}
