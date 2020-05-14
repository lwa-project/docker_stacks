ARG BASE_CONTAINER=jaycedowell/lsl:base
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        emacs \
        firefox \
        fonts-dejavu \
        fonts-ubuntu \
        gettext \
        libglib2.0-dev \
        libgtk-3-dev \
        libjpeg-dev \
        liblzma-dev \
        libpng-dev \
        libtiff5-dev \
        libwebkitgtk-3.0-dev \
        libwxgtk3.0-dev \
        nano \
        xfonts-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install wx
RUN pip install wxpython && \
    rm -rf /home/$LSL_USER/.cache/yarn && \
    fix-permissions /home/$LSL_USER

USER $LSL_UID

# Download the extension
RUN git clone https://github.com/lwa-project/session_schedules.git

# Setup the extension
RUN cd $HOME/session_schedules && \
    git checkout new-lsl-api

# Done
ENTRYPOINT ["/bin/bash", "-i"]
