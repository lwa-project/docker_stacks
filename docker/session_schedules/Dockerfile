ARG BASE_CONTAINER=jaycedowell/lsl:base
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -yq --no-install-recommends \
    firefox \
    vim \
    emacs \
    nano \
    libxxf86vm1 \
    fonts-dejavu \
    fonts-ubuntu \
    xfonts-base 
    
# Install wx
RUN conda install --quiet --yes wxpython && \
    rm -rf /home/$LSL_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$LSL_USER

USER $LSL_UID

# Download the extension
RUN git clone https://github.com/lwa-project/session_schedules.git

# Setup the extension
RUN cd $HOME/session_schedules && git checkout new-lsl-api

# Done
ENTRYPOINT ["/bin/bash", "-i"]