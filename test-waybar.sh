#!/bin/sh

STYLES="$HOME/my-nixos/waybar/styles.css"

ls ./waybar/* | entr -rz waybar -s $STYLES