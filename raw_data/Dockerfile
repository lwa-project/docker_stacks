ARG BASE_CONTAINER=jaycedowell/lsl:session_schedules
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

WORKDIR $HOME

# Download the extensions
RUN git clone https://github.com/lwa-project/commissioning.git

# Setup the extensions
RUN cd $HOME/commissioning/DRX/HDF5/ && make && \
    cd $HOME

# Done
WORKDIR $HOME/commissioning
ENTRYPOINT ["/bin/bash", "-i"]
