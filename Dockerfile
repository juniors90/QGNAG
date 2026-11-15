FROM ubuntu:20.04

LABEL maintainer="Ferreira Juan David <david.ferreira@mi.unc.edu.ar>"

# ---------------------------------------------------------------------------
# Non-root user (Binder requires uid 1000 and HOME=/home/<user>)
# ---------------------------------------------------------------------------
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} \
    NB_UID=${NB_UID} \
    HOME=/home/${NB_USER}

RUN adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}

# ---------------------------------------------------------------------------
# System dependencies
# libzmq3-dev and m4 are required to build ZeroMQInterface (used by JupyterKernel)
# ---------------------------------------------------------------------------
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    apt-get install -y \
    build-essential \
    libgmp-dev \
    git \
    libreadline-dev \
    libncurses-dev \
    libssl-dev \
    libffi-dev \
    python3-pip \
    python3-setuptools \
    wget \
    curl \
    bzip2 \
    sudo \
    cmake \
    zlib1g-dev \
    libgmp3-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libedit-dev \
    libzmq3-dev \
    m4 && \
    apt-get clean

# ---------------------------------------------------------------------------
# GAP 4.13.1
# The release tarball already bundles GBNP, Repsn, RepnDecomp, francy,
# jupyterviz, JupyterKernel, ZeroMQInterface, io, json, uuid, crypting, ...
# Only the packages with C code that JupyterKernel needs are compiled here.
# ---------------------------------------------------------------------------
WORKDIR /tmp
RUN wget -q https://github.com/gap-system/gap/releases/download/v4.13.1/gap-4.13.1.tar.gz \
    && tar -xzf gap-4.13.1.tar.gz \
    && rm gap-4.13.1.tar.gz \
    && mv gap-4.13.1 /gap \
    && cd /gap \
    && ./configure \
    && make -j"$(nproc)" \
    && cd pkg \
    && ../bin/BuildPackages.sh io crypting zeromqinterface uuid json

# ---------------------------------------------------------------------------
# Jupyter Notebook and extensions (same pins that worked locally)
# ---------------------------------------------------------------------------
RUN pip3 install --no-cache-dir \
    'notebook==6.*' \
    jupyter_nbextensions_configurator \
    ipywidgets \
    RISE \
    jupyter_francy \
    jsonschema \
    'jsonpointer>1.13' \
    'isoduration==20.11.0'

RUN pip install --upgrade pip && \
    pip install \
    jupyter_nbextensions_configurator==0.4.1 \
    rise==5.7.1 \
    jupyter_francy==1.0.2 \
    webcolors \
    jsonschema \
    fqdn==1.5.1 \
    uri-template \
    --no-cache-dir

# ---------------------------------------------------------------------------
# Make GAP and the GAP Jupyter kernel launcher visible to Jupyter
# ---------------------------------------------------------------------------
ENV GAP_HOME=/gap \
    JUPYTER_GAP_EXECUTABLE=/gap/gap \
    PATH=/gap:/gap/pkg/jupyterkernel/bin:${PATH}

USER ${NB_USER}
WORKDIR ${HOME}

# Register the kernel under the same name the notebook was saved with
RUN jupyter kernelspec install --user --name gapcito /gap/pkg/jupyterkernel/etc/jupyter

# Notebook extensions (must run as the final user because of --user)
RUN jupyter nbextensions_configurator enable --user && \
    jupyter nbextension install rise --py --user && \
    jupyter nbextension enable rise --py --user && \
    jupyter nbextension enable jupyter_francy --py --user

# ---------------------------------------------------------------------------
# QGNAG: the repository root IS the GAP package (PackageInfo.g at the top).
# It is copied to ~/qgnag so the notebooks show up in the Jupyter file browser.
# Kept after the heavy layers so editing the repo never rebuilds GAP.
# ---------------------------------------------------------------------------
COPY . ${HOME}/qgnag
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Build QGNAG's C++ kernel extension (runs ./configure /gap and make)
RUN /gap/bin/BuildPackages.sh --with-gaproot=/gap qgnag

# Make the package visible to GAP through the user root (~/.gap/pkg)
RUN mkdir -p ${HOME}/.gap/pkg && ln -s ${HOME}/qgnag ${HOME}/.gap/pkg/qgnag

# Fail the image build right here if QGNAG cannot be loaded
RUN echo 'if LoadPackage("QGNAG") <> true then FORCE_QUIT_GAP(1); fi; QUIT_GAP(0);' | gap -q
