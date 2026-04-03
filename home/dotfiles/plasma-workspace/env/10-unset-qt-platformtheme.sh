#!/bin/sh

# Niri pushes QT_QPA_PLATFORMTHEME into the user activation environment so
# dbus/systemd-activated Qt apps also see qt6ct. Clear it again for Plasma,
# which should use KDE's own platform theme integration.
unset QT_QPA_PLATFORMTHEME

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user unset-environment QT_QPA_PLATFORMTHEME >/dev/null 2>&1 || true
fi

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment QT_QPA_PLATFORMTHEME= >/dev/null 2>&1 || true
fi
