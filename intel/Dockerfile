FROM ubuntu:20.04
LABEL version="0.5"
LABEL description="Docker Steam app Mesa version"

ARG NAME_APP=steam
ARG GPU_TYPE=INTEL
ARG GPU_DRIVER="i915"
ARG IS_32BIT=true

ENV DEBIAN_FRONTEND=noninteractive

# # Prepare System: Add 32Bit suuport ! 
RUN apt-get update && apt-get dist-upgrade -qq -y
RUN apt-get install -y --no-install-recommends apt-utils dpkg pciutils \
    xz-utils fonts-symbola ttf-ubuntu-font-family ttf-mscorefonts-installer \
    wget gdebi-core gpg-agent software-properties-common apt-transport-https \
    libsm6 libxext6 dialog ffmpeg

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get dist-upgrade -qq -y
# Desktop Integration for Containerd App ?
RUN apt-get install -y --no-install-recommends xdg-desktop-portal \
    xdg-desktop-portal-gtk pipewire dbus dbus-x11 xauth xserver-xorg \
    xserver-xorg-video-intel xserver-xorg-video-fbdev

# For GUI App
RUN apt-get install -y --no-install-recommends libgtk-3-0 appmenu-gtk3-module  \
    libcanberra-gtk3-module libfontconfig1:i386

# # Install Graphics Driver #
RUN apt-get install -y --no-install-recommends libdrm-intel1 mesa-va-drivers \ 
    vulkan-validationlayers mesa-vulkan-drivers libvulkan1 \
    libgl1-mesa-dri libgl1-mesa-glx libegl-mesa0 libgles2 \
    libxcb-xvmc0 libglx-mesa0 libglx0 libegl1 libgles2  \
    libglapi-mesa libegl-mesa0 gamemode libgamemode0 libgamemodeauto0 libglvnd0 

RUN apt-get install -y --no-install-recommends mesa-vulkan-drivers:i386 libvulkan1:i386 \
    libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libxvmc1:i386 libc6:i386 \
    libxcb-xvmc0:i386 libglx-mesa0:i386 libglapi-mesa:i386 libegl-mesa0:i386 libglvnd0:i386 libgl1:i386 \
    libglx0:i386 libgl1:i386 libgles2:i386 libegl1 libegl1:i386 

## Sound Driver ##
RUN apt-get install -y --no-install-recommends pulseaudio alsa-base libopenal1
RUN apt-get install -y --no-install-recommends pulseaudio:i386
RUN sed -i "s/; enable-shm = yes/enable-shm = no/g" /etc/pulse/daemon.conf && \
    sed -i "s/; enable-shm = yes/enable-shm = no/g" /etc/pulse/client.conf

# Install Network Security Service, X11 Screen Saver, Web content engine library for Gtk3
RUN apt-get install -y --no-install-recommends libnss3 \
    libxss1 gir1.2-webkit2-4.0 libwebkit2gtk-4.0-37 \
    webkit2gtk-driver gstreamer1.0-gl gstreamer1.0-plugins-good \
    gstreamer1.0-libav

# ## ========================== Install Steam ## ===================================
RUN wget -O steam.deb https://cdn.akamai.steamstatic.com/client/installer/steam.deb --no-check-certificate && \
    gdebi --n steam.deb  && rm -rf steam.deb

# ## After install ##
RUN apt-get update -y && apt-get dist-upgrade -qq -y --no-install-recommends

# Remove unnecesary App #
RUN apt-get autoremove -y --purge gdebi-core
# ## ====================== END Install Steam ## ===================================

# Remove info, man and docs, cache
RUN rm -rf /usr/share/info/*     && \
    rm -rf /usr/share/man/*  && \
    rm -rf /usr/share/doc/*
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# ADD USER #
RUN useradd -rm -d /home/"${NAME_APP}" -s /bin/bash -g root -G sudo -u 1000 "${NAME_APP}"
USER "${NAME_APP}"
WORKDIR /home/"${NAME_APP}"

ENV HOME=/home/"${NAME_APP}"
VOLUME ["/home/${NAME_APP}"]

# # ENV #
ENV MESA_DEBUG="silent"
ENV VAAPI_MPEG_ENABLE=1
ENV WINEESYNC="1"
ENV WINEDEBUG="-all"
ENV DXVK_LOG_LEVEL="none"
ENV LIBVA_DRIVER_NAME=${GPU_DRIVER}
ENV MESA_LOADER_DRIVER_OVERRIDE=${GPU_DRIVER}
# ## None paste LD_preload ?? Or Vulkan ICD ?
ENV LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1'
# # Resolve Warning: "lavapipe is not a conformant Vulkan implementation, testing use only." (quoted from the driver itself)
ENV VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/intel_icd.i686.json:/usr/share/vulkan/icd.d/intel_icd.x86_64.json'
# ENV LIBGL_ALWAYS_SOFTWARE=1 

## --- Test For ZINK --- ##
#ENV MESA_LOADER_DRIVER_OVERRIDE=zink

# Running Steam App #
CMD ["/usr/bin/./steam"]

