#!/bin/bash

set -ouex pipefail

# Copy system files into image
cp -avf "/ctx/system_files"/. /

### Install packages

dnf5 install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Development tools - Minecraft modding maven
dnf5 install -y \
    maven

# Install Gradle manually
GRADLE_VERSION="8.8"
mkdir -p /opt/gradle
curl -L --fail --retry 3 \
    "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    -o /tmp/gradle.zip || { echo "Gradle download failed"; exit 1; }

unzip -q /tmp/gradle.zip -d /opt/gradle || { echo "Gradle extraction failed"; exit 1; }
rm -f /tmp/gradle.zip

ln -sf /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin/gradle

# Development tools - Game development (Godot)
dnf5 install -y \
    godot \
    scons

# Development tools - FL Studio composition / Audio production
dnf5 install -y \
    wine \
    wine-mono \
    wine-gecko \
    bottle \
    calf-studio-gear \
    x42-plugins \
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
    fluidsynth-devel \
    libsndfile

# yabridge (VST bridge for Windows plugins on Linux)
mkdir /opt/yabridge

curl -L --fail --retry 3 \
    https://github.com/robbert-vdh/yabridge/releases/latest/download/yabridge.tar.gz \
    -o /tmp/yabridge.tar.gz || { echo "yabridge download failed"; exit 1; }

tar -xf /tmp/yabridge.tar.gz -C /opt/yabridge --strip-components=1 || { echo "tar extraction failed"; exit 1; }
rm -f /tmp/yabridge.tar.gz

[[ -f /opt/yabridge/yabridge ]] || { echo "yabridge executable not found"; exit 1; }
[[ -f /opt/yabridge/yabridgectl ]] || { echo "yabridgectl executable not found"; exit 1; }

ln -sf /opt/yabridge/yabridge /usr/local/bin/yabridge
ln -sf /opt/yabridge/yabridgectl /usr/local/bin/yabridgectl

# Flatpak applications
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y flathub \
    com.discordapp.Discord \
    com.blender.Blender \
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
