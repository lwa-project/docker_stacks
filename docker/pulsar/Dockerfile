ARG BASE_CONTAINER=jaycedowell/lsl:session_schedules
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        tcsh \
        automake \
        autoconf \
        libtool \
        gfortran \
        g++ \
        swig \
        pgplot5 \
        libc6-dev \
        libgsl-dev \
        libexpat1-dev \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
## Install wx
#RUN conda install --quiet --yes wxpython && \
#    rm -rf /home/$LSL_USER/.cache/yarn && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$LSL_USER

# Setup TEMPO
ENV TEMPO=/home/$LSL_USER/tempo
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/tempo/tempo && \
    cd tempo && \
    git checkout 6bab1083350eca24745eafed79a55156bdd1e7d5 && \
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
COPY backend_common.patch /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone https://github.com/scottransom/presto.git && \
    cd presto && \
    git checkout e90b8148f813c151f588f5f94b81b606964b03a8 && \
    patch -p0 src/backend_common.c < /home/$LSL_USER/backend_common.patch && \
    cd src && make prep && CFLAGS=-I. make && \
    fix-permissions /home/$LSL_USER

# Setup EPSIC
RUN cd /home/$LSL_USER && \
    git clone https://github.com/straten/epsic.git && \
    cd epsic && \
    git checkout 5315cc634f6539ea0a34e403e492472b97e0f086 && \
    cd src && ./bootstrap && ./configure && make && make install && \
    fix-permissions /home/$LSL_USER

# Setup PSRCHIVE
COPY ac_python_devel.m4 /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/psrchive/code psrchive && \
    cd psrchive && \
    python-config --cflags && \
    git checkout ca12b4a279f3d4adcca223508116d9d270df8cc6 && \
    mv /home/$LSL_USER/ac_python_devel.m4 config/ && \
    ./bootstrap && ./configure --enable-shared --disable-tempo2 --with-psrcat=/home/$LSL_USER/psrcat/ && \
    make && make install && \
    fix-permissions /home/$LSL_USER

# Setup DSPSR
RUN cd /home/$LSL_USER && \
    git clone git://git.code.sf.net/p/dspsr/code dspsr && \
    cd dspsr && \
    git checkout c277eba1e05ffa5e03310b13c2a0f0477758cf4f && \
    ./bootstrap && ./configure --enable-shared && make && make install && \
    fix-permissions /home/$LSL_USER

# Setup psrfits_utils
RUN cd /home/$LSL_USER && \
    git clone https://github.com/lwa-project/psrfits_utils.git && \
    cd psrfits_utils && \
    ./prepare && ./configure --prefix=$HOME && make && make install && \
    fix-permissions /home/$LSL_USER

USER $LSL_UID
WORKDIR $HOME

# Download the extensions
RUN git clone https://github.com/lwa-project/commissioning.git && \
    git clone https://github.com/lwa-project/pulsar.git

# Setup the extensions
RUN cd $HOME/commissioning && git checkout new-lsl-api && \
    cd $HOME/pulsar && git checkout new-lsl-api && \
    cd $HOME

# Done
ENTRYPOINT ["/bin/bash", "-i"]
