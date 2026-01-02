{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.firefoxpwa
    ];

    profiles.sampaiol = {
      search = {
        force = true;
        default = "google";
      };

      settings = {
        browser = {
          tabs.warnOnClose = false;
          download.panel.shown = true;
        };
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = [
                  "wiki"
                  "nix"
                ];
                url = "https://wiki.nixos.org/";
              }
            ];
          }
        ];
      };

      containersForce = true;
      containers = {
        Personal = {
          color = "cyan";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "orange";
          icon = "briefcase";
          id = 2;
        };
      };

      spacesForce = true;
      spaces =
        let
          containers = config.programs.zen-browser.profiles.sampaiol.containers;
        in
        {
          Personal = {
            id = "f6a2bc83-520f-4622-8399-0c2ed90c8774";
            position = 1000;
            icon = "😎";
            container = containers.Personal.id;
            theme = {
              type = "gradient";
              opacity = 0.8;
              texture = 0.5;
              colors = [
                {
                  red = 185;
                  green = 200;
                  blue = 215;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
            };
          };

          Work = {
            id = "684dff1f-2c6d-4890-a0b1-513c06212d52";
            position = 2000;
            icon = "💼";
            container = containers.Work.id;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 150;
                  green = 190;
                  blue = 230;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.2;
              texture = 0.5;
            };
          };
        };

      pins = {
        Gmail = {
          id = "8590604c-ec6b-47e4-8bdd-96274ae9ebda";
          container = containers.Personal.id;
          url = "https://gmail.com/";
          isEssential = true;
          position = 101;
        };
        WhatsApp = {
          id = "6a7fa275-01ca-4728-b3d6-c44e9b826c5d";
          container = containers.Personal.id;
          url = "https://web.whatsapp.com/";
          isEssential = true;
          position = 102;
        };
      };
    };
  };
}
