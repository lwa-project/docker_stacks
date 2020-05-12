FROM ubuntu:bionic

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"
ARG LSL_USER="lwa"
ARG LSL_UID="1000"
ARG LSL_GID="100"

USER root

ARG DEBIAN_FRONTEND=noniteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential \
        curl \
        git \
        pkg-config \
        gzip \
        swig \
        tcsh \
        sudo \
        locales \
        wget \
        bzip2 \
        ca-certificates \
        sudo \
        locales \
        fonts-liberation \
        run-one \
        software-properties-common \
        python-dev \
        python3-dev \
        libgdbm-dev \
        libfftw3-dev \
        libcfitsio-dev \
        libboost-python-dev \
        libhdf5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LSL_USER=$LSL_USER \
    LSL_UID=$LSL_UID \
    LSL_GID=$LSL_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$LSL_USER

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
    mkdir -p $CONDA_DIR && \
    chown $LSL_USER:$LSL_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $LSL_UID
WORKDIR $HOME
ARG PYTHON_VERSION=default

# Install conda as lwa and check the md5 sum provided on the download site
ENV MINICONDA_VERSION=4.8.2 \
    MINICONDA_MD5=87e77f097f6ebb5127c77662dfc3165e \
    CONDA_VERSION=4.8.2

RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${MINICONDA_MD5} *Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority strict && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes conda && \
    conda install --quiet --yes pip && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    rm -rf /home/$LSL_USER/.cache/yarn  && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$LSL_USER

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
