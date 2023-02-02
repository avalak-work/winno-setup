# Dockerfile
# https://docker.github.io/engine/reference/builder/

# Base loader
FROM debian:bullseye AS loader
RUN set -eux; \
  sed -i -e 's/\(bullseye.*\)$/\1 non-free/' /etc/apt/sources.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  unzip unrar p7zip-full \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp/dist

# https://innounp.sourceforge.net/
FROM loader AS inno-unpack
ADD https://altushost-swe.dl.sourceforge.net/project/innounp/innounp/innounp%200.50/innounp050.rar /tmp/innounp.rar
RUN set -eux; \
  cd /tmp/dist \
  && unrar x -y /tmp/innounp.rar

# https://portapps.io/app/innosetup-portable/
FROM loader as inno-setup
ADD https://github.com/portapps/innosetup-portable/releases/download/6.2.0-5/innosetup-portable-win32-6.2.0-5.7z /tmp/dist/innosetup.7z
RUN set -eux; \
  cd /tmp/dist \
  && 7z x -y /tmp/dist/innosetup.7z

# Main image
FROM debian:bullseye
RUN set -eux; \
  dpkg --add-architecture i386 \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  apt-transport-https gnupg curl cabextract unzip p7zip-full winbind xvfb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV WINE_VERSION=8.0.0.0~bullseye-1
RUN set -eux; \
  curl -L https://dl.winehq.org/wine-builds/winehq.key | tee /etc/apt/trusted.gpg.d/winehq.asc \
  && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list \
  && apt-get update \
  && apt-cache madison wine-stable:i386 \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends \
  wine-stable-i386=${WINE_VERSION} wine-stable:i386=${WINE_VERSION} winehq-stable:i386=${WINE_VERSION} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.winehq.org/Gecko
# https://wiki.winehq.org/Mono
#RUN set -eux; \
#    mkdir -p /usr/share/wine/gecko/ && cd /usr/share/wine/gecko/ \
#    && curl -O http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi \
#    && mkdir -p /usr/share/wine/mono && cd /usr/share/wine/mono \
#    && curl -O https://dl.winehq.org/wine/wine-mono/6.3.0/wine-mono-6.3.0-x86.msi

RUN set -eux; \
  curl https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks \
  && chmod +x /usr/local/bin/winetricks

ENV USER_PATH /opt/wineuser
RUN useradd -b /opt -m -d ${USER_PATH} wineuser
RUN mkdir /wine /Data && chown wineuser.wineuser /wine /Data
USER wineuser
RUN mkdir -p /opt/wineuser/.cache/winetricks/
ENV WINEPREFIX=/wine
ENV WINEARCH=win32
RUN wineboot --update && wineserver --wait

ADD ./entrypoint.sh /usr/bin/entrypoint.sh
COPY --from=inno-unpack /tmp/dist /wine/drive_c/inno
COPY --from=inno-setup /tmp/dist/app /wine/drive_c/inno

WORKDIR /Data

# WINEDEBUG fixme-all -all
ENV WINEDEBUG=-all
ENTRYPOINT [ "entrypoint.sh" ]
CMD [  ]
