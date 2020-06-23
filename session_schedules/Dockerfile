ARG BASE_CONTAINER=lwaproject/lsl:base
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - session schedules image" \
      org.label-schema.description="Image for scheduling observations on the LWA" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

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

# Done
ENTRYPOINT ["/bin/bash", "-i"]
