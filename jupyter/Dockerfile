ARG BASE_CONTAINER=lwaproject/lsl:base
FROM $BASE_CONTAINER

LABEL maintainer="Jayce Dowell <jdowell@unm.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="LWA Software Library - Jupyter image" \
      org.label-schema.description="Image with LSL and a useful Jupyter stack" \
      org.label-schema.url="https://lwa.unm.edu" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/lwa-project/docker_stacks" \
      org.label-schema.schema-version="1.0"

USER root

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        bzip2 \
        ca-certificates \
        emacs-nox \
        fonts-liberation \
        inkscape \
        jed \
        libsm6 \
        libxext-dev \
        libxrender1 \
        lmodern \
        nano \
        netcat \
        run-one \
        swig \
        tcsh \
        # ---- nbconvert dependencies ----
        texlive-xetex \
        texlive-fonts-recommended \
        texlive-generic-recommended \
        # Optional dependency
        texlive-fonts-extra \
        # ----
        tzdata \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup work directory for backward-compatibility
RUN mkdir /home/$LSL_USER/work && \
    fix-permissions /home/$LSL_USER

# Install Tini
RUN pip install tini && \
    fix-permissions /home/$LSL_USER

# Setup Jupyter
RUN pip install \
        jupyterlab \
        jupyterhub \
        jupyter_client \
        jupyter_bokeh \
        nbformat \
        nbconvert && \
    jupyter notebook --generate-config && \
    rm -rf /home/$LSL_USER/.cache/yarn && \
    fix-permissions /home/$LSL_USER

EXPOSE 8888

# Configure container startup
# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
CMD ["start-notebook.sh"]

# Copy local files as late as possible to avoid cache busting
COPY start.sh start-notebook.sh start-singleuser.sh /usr/local/bin/
RUN chmod a+rx /usr/local/bin/start*.sh
COPY jupyter_notebook_config.py /etc/jupyter/

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$LSL_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$LSL_USER

# Switch back to lwa to avoid accidental container runs as root
USER $LSL_UID
