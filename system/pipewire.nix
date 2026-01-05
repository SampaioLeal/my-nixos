{ pkgs, ... }:
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # lowLatency.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = false
          }
        '')
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
          monitor.bluez.properties = {
            bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
            bluez5.codecs = [ sbc sbc_xq aac ldac ]
            bluez5.enable-sbc-xq = true
            bluez5.hfphsp-backend = "native"
          }
        '')
      ];
    };
  };

  hardware.alsa.enablePersistence = true;

  environment.systemPackages = with pkgs; [
    playerctl
    wiremix
  ];
}
