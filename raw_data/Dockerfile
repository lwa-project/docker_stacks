ARG BASE_CONTAINER=lwaproject/lsl:session_schedules
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - raw data image" \
      org.label-schema.description="Image for scheduling and working with raw data observations from the LWA" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

# virtualenv missing python-config/includes fix
RUN ln -s `realpath $VIRTUAL_ENV/bin/python`-config $VIRTUAL_ENV/bin/python-config
RUN ln -s /usr/share $VIRTUAL_ENV/share
RUN ln -s /usr/include $VIRTUAL_ENV/include

USER $LSL_UID
WORKDIR $HOME

# Download the extensions
RUN git clone https://github.com/lwa-project/commissioning.git

# Done
WORKDIR $HOME/commissioning
RUN pip install -r requirements.txt
ENTRYPOINT ["/bin/bash", "-i"]
