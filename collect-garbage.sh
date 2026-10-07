#!/usr/bin/env bash
set -euo pipefail
sudo nix-collect-garbage --delete-older-than 7d
nix-collect-garbage --delete-older-than 7d
nix store optimise
# ou simplesmente: nh clean all --keep-since 7d --keep 5
