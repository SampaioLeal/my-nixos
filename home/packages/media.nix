{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lowfi
    ffmpeg
    ffmpegthumbnailer
    imagemagick
    transmission_4-gtk
    hyprpicker
  ];
}
