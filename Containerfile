FROM ubuntu:26.04 AS source

ADD --checksum=sha256:d3c05df0259ab116d11d8c1cdc1403019d2a3be303ad3b46d16a84e19df6615f \
    https://github.com/telegramdesktop/tdesktop/releases/download/v7.0.9/tsetup.7.0.9.tar.xz \
    /tmp/telegram.tar.xz
ADD --checksum=sha256:e297771c75bd2f81d637a3234f83568be62092f67d16946be23895fa92fa7119 \
    https://raw.githubusercontent.com/telegramdesktop/tdesktop/v7.0.9/Telegram/Resources/art/icon512.png \
    /tmp/telegram.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends xz-utils && \
    mkdir -p /out && \
    tar -xJf /tmp/telegram.tar.xz --strip-components=1 -C /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out /opt/telegram
COPY --from=source /tmp/telegram.png /usr/share/icons/hicolor/512x512/apps/telegram.png
COPY org.telegram.desktop /usr/share/applications/org.telegram.desktop
COPY --chmod=0755 telegram-desktop /usr/bin/telegram-desktop

RUN apt update && \
    apt install -y --no-install-recommends \
      libasound2t64 libgtk-3-0 libnss3 libxcb-keysyms1 libxcb-record0 \
      libxkbcommon-x11-0 xdg-utils && \
    cpak-clean-junk
