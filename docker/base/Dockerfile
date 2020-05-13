FROM ubuntu:bionic

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"
ARG LSL_USER="lwa"
ARG LSL_UID="1000"
ARG LSL_GID="100"

USER root

ARG DEBIAN_FRONTEND=noniteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        sudo \
        build-essential \
        curl \
        git\
        vim \
        wget \
        pkg-config \
        locales \
        software-properties-common \
        python3-dev \
        python3-pip \
        python3-setuptools \
        libgdbm-dev\ 
        libfftw3-dev \
        libcfitsio-dev \
        libboost-python-dev \
        libhdf5-dev && \
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
        pyephem==3.7.6.0 && \
    pip install "astropy<3.2" && \
    pip install aipy && \
    pip install git+https://github.com/lwa-project/lsl.git

# Switch back to lwa to avoid accidental container runs as root
USER $LSL_UID
