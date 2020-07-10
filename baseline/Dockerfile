ARG BASE_CONTAINER=lwaproject/lsl:session_schedules
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - single baseline image" \
      org.label-schema.description="Image for scheduling and working with data from the LWA single baseline interferometer" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        evince \
        gfortran \
        gv \
        libncurses5-dev \
        libx11-dev \
        libxext6 \
        perl \
        pgplot5 \
        rsync \
        xterm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install difmap
RUN wget ftp://ftp.astro.caltech.edu/pub/difmap/difmap2.5e.tar.gz && \
    tar xzvf difmap2.5e.tar.gz && \
    cd uvf_difmap && \
    ./configure linux-ia64-gcc && \
    ./makeall && \
    cp difmap /usr/local/bin/ && \
    fix-permissions $HOME
    
USER $LSL_UID
WORKDIR $HOME

# Prepare to install AIPS
RUN mkdir $HOME/aips && \
    mkdir -p $HOME/aips/DA00/DOCKER && \
    touch $HOME/aips/DA00/DOCKER/SPACE && \
    mkdir -p $HOME/aips/DATA/LOCALHOST_1 && \
    touch $HOME/aips/DATA/LOCALHOST_1/SPACE
COPY AIPSRC $HOME/.AIPSRC
COPY DADEVS.LIST $HOME/aips/DA00/
COPY PRDEVS.LIST $HOME/aips/DA00/
COPY TPDEVS.LIST $HOME/aips/DA00/
COPY NETSP $HOME/aips/DA00/
COPY TPHOSTS $HOME/aips/DA00/

# Install AIPS
RUN wget ftp://ftp.aoc.nrao.edu/pub/software/aips/31DEC20/install.pl && \
    echo -e "\n\n\n" | perl ./install.pl -n && \
    echo ". /home/lwa/aips/LOGIN.SH" >> $HOME/.bashrc && \
    echo "alias aips='aips tv=local:0'" >> $HOME/.bashrc

# Done
WORKDIR $HOME
ENTRYPOINT ["/bin/bash", "-i"]
