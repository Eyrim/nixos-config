{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

    hardware = {
        bluetooth = {
            enable = true;
        };

        pulseaudio = {
            enable = false;
        };
    };

    networking = {
        networkmanager = {
            enable = true;
        };

        hostName = "nixos";
    };


services = {
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    xserver = {
        enable = true;
        
        dpi = 220;

        libinput = {
            enable = true;

            touchpad = {
                naturalScrolling = true;
               accelProfile = "flat";
            };

            mouse = {
                naturalScrolling = false;
               accelProfile = "flat";
            };
        };

        xkb = {
            layout = "gb";
            variant = "";
        };
        xkbOptions = "caps:swapescape";

        displayManager = {
            gdm = {
                enable = false;
            };

            sddm = {
                enable = true;
            };

            autoLogin = {
                enable = true;

                user = "eyrim";
            };
        };

        desktopManager = {
            gnome = {
                enable = true;
            };
        };

        windowManager = {
            awesome = {
                enable = true;
            };
        };
    };

      # Enable CUPS to print documents.
    printing = {
        enable = true;
    };
  };

  # Configure console keymap
  console.keyMap = "uk";

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eyrim = {
    isNormalUser = true;
    description = "eyrim";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	neovim
	git
	tmux
	unzip
        vesktop
        fzf
        docker
	wezterm
        awesome

        # Build Tools
	libGLU
	cmake
	ninja

	pkg-config

        # Lib
	xz # xz-utils
	gtk3
	libstdcxx5

        # Languages etc.
	cargo
	flutter319
	gcc
	libgcc
	nodejs_22
	yarn

	# Language Servers
	lua-language-server
	kotlin-language-server
	nil # nix ls
        nodePackages.bash-language-server
        dockerfile-language-server-nodejs
        typescript

	# Formatters
	stylua
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "eyrim" = import ./home.nix;
    };
  };
  users.users.eyrim.shell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

