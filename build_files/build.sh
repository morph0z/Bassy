#!/bin/bash

set -ouex pipefail

# Copy system files into image
cp -avf "/ctx/system_files"/. /

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

### Enable services
systemctl enable podman.socket

### Aggressive Cleanup
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

### Enable services
systemctl enable podman.socket

### Aggressive Cleanup
dnf5 clean all
rm -rf /var/cache/dnf/*
