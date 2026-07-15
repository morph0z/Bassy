#!/bin/bash

set -ouex pipefail

# Copy system files into image
cp -avf "/ctx/system_files"/. /

### Install packages

dnf5 install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

dnf5 update -y

# Development tools - Minecraft modding
dnf5 install -y \
    maven

# Development tools - Game development (Godot)
dnf5 install -y \
    godot \
    scons

# Development tools - FL Studio composition / Audio production
dnf5 install -y \
    wine \
    wine-mono \
    helm \
    lv2 \
    lilv \
    lilv-devel \
    suil \
    suil-devel \
    liblo-devel \
    fftw-devel \
    soundfont-utils \
    timidity++ \
    fluidsynth \
    fluidsynth-devel

# Flatpak applications
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y flathub \
    com.discordapp.Discord \
    org.blender.Blender \
    org.audacityteam.Audacity \
    org.godotengine.Godot \
    com.modrinth.ModrinthApp \
    md.obsidian.Obsidian \
    org.prismlauncher.PrismLauncher \
    ar.com.tuxguitar.TuxGuitar \
    com.spotify.Client || { echo "Flatpak installation failed"; exit 1; }

### Enable services

systemctl enable podman.socket

### Cleanup

dnf5 clean all
