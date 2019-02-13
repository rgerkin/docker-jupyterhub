FROM continuumio/miniconda3:latest

Label Joerg Klein <kwp.klein@gmail.com>

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
    && conda clean -ay

RUN pip install \
    oauthenticator \
    nbdime \
    allensdk \
    quantities \
    brian2

git config --global user.email "rgerkin@asu.edu"
git config --global user.name "Rick Gerkin"
nbdime config-git --enable --global
jupyter lab build

COPY jupyterhub_config.py /

# Create admin user
RUN useradd -ms /bin/bash rgerkin

# Setup application
EXPOSE 8000

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]

