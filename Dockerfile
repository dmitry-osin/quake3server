FROM ubuntu:24.04

LABEL maintainer="Dmitry Osin"
LABEL description="Quake 3 Arena Server"

ENV SV_HOSTNAME "AktiveHatex Server"
ENV G_GAMETYPE 1
ENV FRAG_LIMIT 0
ENV TIME_LIMIT 10
ENV SV_MAXCLIENTS 24
ENV NET_PORT 26960
ENV RCON_PASSWORD qwerty
ENV SV_DEDICATED 2
ENV G_QUADFACTOR 3
ENV G_INACTIVITY 120
ENV SV_ALLOWDOWNLOAD 1
ENV G_ALLOWVOTE 1
ENV COM_HUNKMEGS 256
ENV SV_PURE 1
ENV MAP bloodrun
ENV FS_GAME osp
ENV CONFIG_FILE 1v1.cfg

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    make \
    mc \
    gcc \
    g++ \
    htop \
    gcc-multilib \
    g++-multilib \
    libsdl1.2debian \
    libcurl4-openssl-dev \
    libopusfile-dev \
    libopus-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/ioq3srv -s /bin/bash ioq3srv
RUN chown -R ioq3srv:ioq3srv /home/ioq3srv

USER ioq3srv
WORKDIR /home/ioq3srv/

RUN git clone https://github.com/ioquake/ioq3.git && \
    cd ioq3 && \
    export BUILD_CLIENT=0 && \
    export BUILD_SERVER=1 && \
    export USE_CURL=1 && \
    export USE_CODEC_OPUS=1 && \
    export USE_VOIP=1 && \
    export COPYDIR=/home/ioq3srv/server && \
    make -j$(nproc) && \
    make copyfiles

RUN mkdir -p /home/ioq3srv/server/baseq3

VOLUME ["/home/ioq3srv/server/baseq3"]

EXPOSE $NET_PORT/udp

RUN echo '#!/bin/sh' > /home/ioq3srv/start_server.sh && \
    echo 'exec /home/ioq3srv/server/ioq3ded.x86_64 +exec $CONFIG_FILE \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +set fs_game $FS_GAME \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta sv_hostname "$SV_HOSTNAME" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +set net_port "$NET_PORT" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta g_gametype "$G_GAMETYPE" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta fraglimit "$FRAG_LIMIT" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta timelimit "$TIME_LIMIT" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta sv_maxclients "$SV_MAXCLIENTS" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta sv_pure "$SV_PURE" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta sv_dedicated "$SV_DEDICATED" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta g_quadfactor "$G_QUADFACTOR" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta g_inactivity "$G_INACTIVITY" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta sv_allowdownload "$SV_ALLOWDOWNLOAD" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta g_allowvote "$G_ALLOWVOTE" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta rconpassword "$RCON_PASSWORD" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +seta com_hunkmegs "$COM_HUNKMEGS" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  +map "$MAP" \\' >> /home/ioq3srv/start_server.sh && \
    echo '  "$@"' >> /home/ioq3srv/start_server.sh && \
    chmod +x /home/ioq3srv/start_server.sh

ENTRYPOINT ["/home/ioq3srv/start_server.sh"]