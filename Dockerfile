FROM continuumio/miniconda3:latest

# Original: Joerg Klein <kwp.klein@gmail.com>
# Modifications: Rick Gerkin <rgerkin at asu dot edu>

# Install OS packages and clean up
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    git \
    nano \
    unzip \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install and update many packages with conda
RUN conda update -y conda
RUN conda install -c conda-forge jupyter_nbextensions_configurator \
    jupyterhub \
    jupyterlab \
    numpy \
    matplotlib \
    pandas \
    scipy \
    sympy \
    rise \
    seaborn \
    scikit-learn \
    ipyvolume \
    h5py \
    requests \
    nbgrader \
    scikit-image \
    pymc3 \
    pystan \
    rpy2 \
    tzlocal \
    pip \
    arviz \
    && conda clean -ay

# Neuroscience stuff
RUN conda install -c conda-forge \
    brian2 \
    neuron

# Packages that are only on pip
RUN pip install \
oauthenticator \
    nbdime \
    quantities \
    fastcluster \
    rickpy \
    allensdk

# Setup Jupyter Lab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install ipyvolume
RUN jupyter labextension install jupyter-threejs
RUN jupyter lab build

# Rick's branch of JupyterHub
ADD https://api.github.com/repos/rgerkin/jupyterhub/git/refs/heads/master jupyterhub_version.json
RUN git clone https://github.com/rgerkin/jupyterhub
WORKDIR jupyterhub
RUN pip install -e .
WORKDIR ..

# SciUnit
ADD https://api.github.com/repos/scidash/sciunit/git/refs/heads/master sciunit_version.json
RUN git clone https://github.com/scidash/sciunit
WORKDIR sciunit
RUN pip install -e .
WORKDIR ..

# Git configuration
RUN git config --global user.email "rgerkin@asu.edu"
RUN git config --global user.name "Rick Gerkin"
RUN nbdime config-git --enable --global

# Admin files
COPY config /etc/jupyterhub
RUN chmod -R o-rwx /etc/jupyterhub

# Setup application
EXPOSE 8000
CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]
