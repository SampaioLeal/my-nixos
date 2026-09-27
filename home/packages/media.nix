{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lowfi
    ffmpeg
    ffmpegthumbnailer
    imagemagick
    audacity
    transmission_4-gtk
    hyprpicker
  ];
}
