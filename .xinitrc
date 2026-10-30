#!/usr/bin/env sh
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
exec i3
