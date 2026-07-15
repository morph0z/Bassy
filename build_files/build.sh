#!/bin/bash

set -ouex pipefail

# Copy system files into image
cp -avf "/ctx/system_files"/. /

### Install packages

dnf5 install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Development tools
dnf5 install -y \
    cmake \
    ninja-build \
    java-devel \
    git \
    gcc \
    gcc-c++ \
    make \
    pkgconf-pkg-config \
    libglvnd-devel

# Wine compatibility tools
dnf5 install -y \
    winetricks \
    protontricks \
    dxvk \
    vkd3d-proton \
    vulkan-loader \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers.i686 \
    wine-mono \
    wine-gecko

# Audio / music production dependencies
dnf5 install -y \
    pipewire-jack-audio-connection-kit \
    jack-audio-connection-kit \
    alsa-lib-devel \
    libsndfile

# yabridge
mkdir -p /opt/yabridge

curl -L \
    https://github.com/robbert-vdh/yabridge/releases/latest/download/yabridge.tar.gz \
    -o /tmp/yabridge.tar.gz

tar -xf /tmp/yabridge.tar.gz -C /opt/yabridge --strip-components=1

ln -sf /opt/yabridge/yabridge /usr/local/bin/yabridge
ln -sf /opt/yabridge/yabridgectl /usr/local/bin/yabridgectl

# Flatpak applications
flatpak install -y flathub \
    com.discordapp.Discord \
    com.blender.Blender \
    org.audacityteam.Audacity \
    org.godotengine.Godot \
    com.modrinth.ModrinthApp \
    md.obsidian.Obsidian \
    org.prismlauncher.PrismLauncher \
    com.valvesoftware.Steam \
    ar.com.tuxguitar.TuxGuitar

### Enable services

systemctl enable podman.socket

### Cleanup

dnf5 clean all
