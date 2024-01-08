FROM lwaproject/lsl:raw_data

LABEL maintainer="Sarah Chastain <sarahchastain1@unm.edu>"


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
        zlib1g-dev \
        libpng-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ENV PSRHOME=/opt/lwa/Pulsar
ENV PATH=${PATH}:$PSRHOME/bin

ENV TEMPO2=/usr/local/lib
ENV PSRCAT_FILE=$PSRHOME/psrcat/psrcat.db

ENV PGPLOT_DIR=$PSRHOME/pgplot5
ENV PGPLOT_FONT=$PGPLOT_DIR/grfont.dat

RUN mkdir -p /opt/lwa/Pulsar

    # install TEMPO2
USER root
RUN cd /opt/lwa/Pulsar && \
    git clone https://git.code.sf.net/p/psrchive/code psrchive && \
    cd psrchive && \
    ./bootstrap && \
    ./configure  && \
    make -j10 && \ 
    make install 

ENTRYPOINT ["/bin/bash", "-i"]
