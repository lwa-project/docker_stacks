ARG BASE_CONTAINER=lwaproject/lsl:raw_data
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - pulsar image" \
      org.label-schema.description="Image for working with scheduling and working with pulsar data from the LWA" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        autoconf \
        automake \
        dirmngr \
        evince \
        g++ \
        gfortran \
        gpg-agent \
        gv \
        libc6-dev \
        libexpat1-dev \
        libgsl-dev \
        libtool \
        pgplot5 \
        swig \
        tcsh \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install CUDA 11.6
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list' && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
        cuda-11-6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV PATH=$PATH:/usr/local/cuda-11.6/bin

# Setup TEMPO
ENV TEMPO=/home/$LSL_USER/tempo
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/tempo/tempo && \
    cd tempo && \
    git checkout 61c8011b0477f005dd4f05ad037fae83c51eafb4 && \
    ./prepare && ./configure && make && make install && \
    fix-permissions /home/$LSL_USER

# Setup PSRCAT
ENV PSRCAT_FILE=/home/$LSL_USER/psrcat/psrcat.db
RUN cd /home/$LSL_USER && \
    wget https://www.atnf.csiro.au/research/pulsar/psrcat/downloads/psrcat_pkg.tar.gz && \
    tar xzvf psrcat_pkg.tar.gz && mv psrcat_tar psrcat && \
    cd psrcat && ./makeit && cp psrcat /usr/local/bin/ && \
    fix-permissions /home/$LSL_USER

# Setup PRESTO
ENV PRESTO=/home/$LSL_USER/presto
ENV PGPLOT_DIR=/usr/lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRESTO/lib
RUN cd /home/$LSL_USER && \
    git clone https://github.com/scottransom/presto.git && \
    cd presto && \
    git checkout v4.0 && \
    cd src && make prep && CFLAGS=-I. make && \
    cd $PRESTO && pip install . && \
    fix-permissions /home/$LSL_USER
ENV PATH=$PATH:$PRESTO/bin

# Setup EPSIC
RUN cd /home/$LSL_USER && \
    git clone https://github.com/straten/epsic.git && \
    cd epsic && \
    git checkout 5315cc634f6539ea0a34e403e492472b97e0f086 && \
    cd src && ./bootstrap && ./configure && make && make install && \
    fix-permissions /home/$LSL_USER

# Setup PSRCHIVE
COPY ac_python_devel.m4 /home/$LSL_USER
COPY python.m4 /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/psrchive/code psrchive && \
    cd psrchive && \
    git checkout a1709aab0948935dcaf5305c0aefd129cf954f8b && \
    mv /home/$LSL_USER/ac_python_devel.m4 config/ && \
    mv /home/$LSL_USER/python.m4 config/ && \
    ./bootstrap && ./configure --enable-shared --disable-tempo2 --with-psrcat=/home/$LSL_USER/psrcat/ && \
    make && make install && \
    fix-permissions /home/$LSL_USER

# Setup DSPSR
COPY backends.list /home/$LSL_USER
COPY python.m4 /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/dspsr/code dspsr && \
    cd dspsr && \
    git checkout 6c762e6fc6bc2a1595000f34bcfc0ca0c43e9954 && \
    mv /home/$LSL_USER/backends.list . && \
    mv /home/$LSL_USER/python.m4 config/ && \
    ./bootstrap && ./configure --enable-shared \
                               --with-cuda-dir=/usr/local/cuda-11.6 \
                               --with-cuda-include-dir=/usr/local/cuda-11.6/include \
                               --with-cuda-lib-dir=/usr/local/cuda-11.6/lib64 && make && make install && \
    fix-permissions /home/$LSL_USER

# Setup psrfits_utils
COPY python.m4 /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone https://github.com/lwa-project/psrfits_utils.git && \
    cd psrfits_utils && \
    mv /home/$LSL_USER/python.m4 config/ && \
    ./prepare && ./configure && make && make install && \
    fix-permissions /home/$LSL_USER

# Update the libraries
RUN ldconfig

USER $LSL_UID
WORKDIR $HOME

# Download the extensions
RUN git clone https://github.com/lwa-project/pulsar.git
RUN git clone https://github.com/lwa-project/pulsar_archive_pipeline.git

# Setup the extensions
RUN cd $HOME/pulsar && make && \
    pip install -r requirements.txt && \
    cd $HOME

# Done
WORKDIR $HOME/pulsar
ENTRYPOINT ["/bin/bash", "-i"]
