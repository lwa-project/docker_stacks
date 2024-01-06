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
        libpng-dev \
        libtool \
        pgplot5 \
        swig \
        tcsh \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PGPLOT_DIR=/usr/lib/pgplot5
ENV PGPLOT_FONT=$PGPLOT_DIR/grfont.dat

# Setup EPSIC
RUN cd /home/$LSL_USER && \
    git clone https://github.com/straten/epsic.git && \
    cd epsic && \
    cd src && ./bootstrap && ./configure --enable-shared && \
    make && make install && \
    cd $HOME && rm -rf epsic && \
    fix-permissions /home/$LSL_USER

# Setup PSRCHIVE
COPY ac_python_devel.m4 /home/$LSL_USER
COPY python.m4 /home/$LSL_USER
RUN cd /home/$LSL_USER && \
    git clone https://git.code.sf.net/p/psrchive/code psrchive && \
    cd psrchive && \
    mv /home/$LSL_USER/ac_python_devel.m4 config/ && \
    mv /home/$LSL_USER/python.m4 config/ && \
    ./bootstrap && ./configure  --enable-shared && \
    make -j10 && make install && \
    cd $HOME && rm -rf psrchive  \
    fix-permissions /home/$LSL_USER


# Done
WORKDIR $HOME/pulsar
ENTRYPOINT ["/bin/bash", "-i"]
