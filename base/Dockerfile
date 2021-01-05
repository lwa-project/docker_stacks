# Ubuntu 18.04 (bionic)
# https://hub.docker.com/_/ubuntu/?tab=tags&name=bionic
# OS/ARCH: linux/amd64
ARG ROOT_CONTAINER=ubuntu:bionic@sha256:c32bd2e76e7688eeb1bb39754fff7cdfc571626fc1abfded4f82a90de79f8d10
ARG BASE_CONTAINER=$ROOT_CONTAINER
FROM $BASE_CONTAINER
FROM ubuntu:bionic

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"
ARG LSL_USER="lwa"
ARG LSL_UID="1000"
ARG LSL_GID="100"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - base image" \
      org.label-schema.description="Image that provides the LWA Software Library Python module" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

USER root

ARG DEBIAN_FRONTEND=noniteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential \
        curl \
        git \
        libboost-python-dev \
        libcfitsio-dev \
        libfftw3-dev \
        libgdbm-dev \
        libhdf5-dev \
        locales \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-setuptools \
        software-properties-common \
        sudo \
        vim \
        wget && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure the environment
ENV SHELL=/bin/bash \
    LSL_USER=$LSL_USER \
    LSL_UID=$LSL_UID \
    LSL_GID=$LSL_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV HOME=/home/$LSL_USER
RUN python3 -m pip install --upgrade virtualenv

# Copy a script that we will use to correct permissions after running certain commands
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default LSL_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create LSL_USER with name lwa user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $LSL_UID $LSL_USER && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME

USER $LSL_UID
WORKDIR $HOME

# Activate the environment
ENV VIRTUAL_ENV=$HOME/venv
RUN python3 -m virtualenv -p python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Setup LSL
RUN pip install \
        setuptools \
        numpy \
        matplotlib \
        scipy \
        h5py \
        pyephem==3.7.6.0 && \
    pip install aipy && \
    pip install lsl

# Switch back to lwa to avoid accidental container runs as root
USER $LSL_UID
