FROM continuumio/miniconda3:latest

Original: Joerg Klein <kwp.klein@gmail.com>
Modifications: Rick Gerkin <rgerkin at asu dot edu>

# Install all OS dependencies for fully functional notebook server
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    git \
    nano \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install conda and Jupyter
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
    scikit-image
    && conda clean -ay

# conda install -c conda-forge nodejs  # or some other way to have a recent nod
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install ipyvolume
RUN jupyter labextension install jupyter-threejs

RUN pip install \
    oauthenticator \
    nbdime \
    quantities \
    fastcluster

# RUN pip install brian2 allensdk

RUN git config --global user.email "rgerkin@asu.edu"
RUN git config --global user.name "Rick Gerkin"
RUN nbdime config-git --enable --global
RUN jupyter lab build

COPY jupyterhub_config_private.json /
COPY jupyterhub_config.py /

# Create admin user
RUN useradd -ms /bin/bash rgerkin

# Setup application
EXPOSE 8000

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]

