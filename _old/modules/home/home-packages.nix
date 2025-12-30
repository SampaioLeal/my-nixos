{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Zen Browser from custom input
    inputs.zen-browser.packages."${system}".default

    # File management and archives
    yazi
    p7zip
    unzip
    zip
    unrar
    file-roller
    ncdu
    duf

    # Version control and development tools
    gh
    lazygit
    lazydocker
    bruno-cli
    warp-terminal
    
    ## Lsp
    nixd # nix

    ## formating
    shfmt
    treefmt
    nixfmt-rfc-style

    obs-studio

    ## Utility
    dconf-editor
    gnome-disk-utility

    spotify

    vscode

    bruno

    # Productivity and office
    obsidian

    # Communication and social
    discord

    # Notifications
    libnotify
    dunst

    # System utilities
    bc
    v4l-utils
    ydotool
    pciutils
    socat
    ripgrep
    lshw
    pkg-config
    brightnessctl
    appimage-run
    yad

    # Screenshots
    grim
    slurp

    # Top Bar
    waybar

    # Virtualization
    libvirt
    qemu
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF

    # File systems
    ntfs3g
    os-prober

    # Clipboard managers
    cliphist

    # Fun and customization
    cmatrix
    lolcat
    fastfetch
    onefetch
    microfetch

    # Miscellaneous
    greetd.tuigreet
    customSddmTheme
    libsForQt5.qt5.qtgraphicaleffects
    
    ## Better core utils
    coreutils
    duf                               # disk information
    eza                               # ls replacement
    fd                                # find replacement
    gping                             # ping with a graph
    gtrash                            # rm replacement, put deleted files in system trash
    hexyl                             # hex viewer
    man-pages                         # extra man pages
    ncdu                              # disk space
    ripgrep                           # grep replacement
    tldr
    fzf
    bat

    ## Tools / useful cli
    asciinema
    asciinema-agg
    binsider
    progress
    exfatprogs
    bitwise                           # cli tool for bit / hex manipulation
    broot                             # tree files view
    caligula                          # User-friendly, lightweight TUI for disk imaging
    hyperfine                         # benchmarking tool
    pastel                            # cli to manipulate colors
    scooter                           # Interactive find and replace in the terminal
    swappy                            # snapshot editing tool
    tdf                               # cli pdf viewer
    tokei                             # project line counter
    translate-shell                   # cli translator
    woomer

    ## TUI
    epy                               # ebook reader
    gtt                               # google translate TUI
    programmer-calculator
    toipe                             # typing test in the terminal
    ttyper                            # cli typing test

    ## Monitoring / fetch
    htop
    wavemon                           # monitoring for wireless network devices
    btop
    lm_sensors
    inxi
    # nvtopPackages.nvidia

    ## Fun / screensaver
    asciiquarium-transparent
    cbonsai
    cmatrix
    countryfetch
    cowsay
    figlet
    fortune
    lavat
    lolcat
    pipes
    sl
    tty-clock

    ## Multimedia
    imv
    lowfi
    mpv
    ffmpeg

    ## Utilities
    entr                              # perform action when file change
    file                              # Show file information
    jq                                # JSON processor
    killall
    libnotify
    mimeo
    openssl
    pamixer                           # pulseaudio command line mixer
    playerctl                         # controller for media players
    poweralertd
    udiskie                           # Automounter for removable media
    unzip
    wget
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    xdg-utils

    # Desktop apps
    anki
    code-cursor
    imv
    mpv
    obs-studio
    obsidian
    pavucontrol
    teams-for-linux
    telegram-desktop
    vesktop

    # CLI utils
    bc
    bottom
    brightnessctl
    cliphist
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    grimblast
    htop
    hyprpicker
    ntfs3g
    mediainfo
    microfetch
    playerctl
    ripgrep
    showmethekey
    silicon
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip

    # Coding stuff
    openjdk23
    nodejs
    python311

    # WM stuff
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}