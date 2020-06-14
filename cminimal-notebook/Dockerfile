# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="@dennischancs/CJupyterDocker"

# add `-u root` login jupyter
COPY start.sh /usr/local/bin/

USER $NB_UID
# Copy local files as late as possible to avoid cache busting
COPY jupyter_notebook_config.py /etc/jupyter/
# # jupyter export PDF use TexLive Chinese Templates
COPY --chown=$NB_USER:users latex $CONDA_DIR/lib/python3.7/site-packages/nbconvert/templates/latex

# change conda repository to tuna
RUN conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority flexible && \
    conda config --system --set channel_alias https://mirrors.tuna.tsinghua.edu.cn/anaconda && \
    conda config --system --append default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main && \
    conda config --system --append default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free && \
    conda config --system --append default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r && \
    conda config --system --append default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro && \
    conda config --system --append default_channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2 && \
    echo "custom_channels:" >> $CONDA_DIR/.condarc && \
    echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    echo "  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    echo "  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    echo "  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" >> $CONDA_DIR/.condarc && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root
# install windows fonts
COPY fonts /usr/share/fonts/winfonts
# Fix permissions on /etc/jupyter as root
RUN fix-permissions /etc/jupyter/ && \
    # change apt-get repository to aliyun & apt-get update
    echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main'> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic main'>> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main'>> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main'>> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic universe'>> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic universe'>> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic-updates universe'>> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates universe'>> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu bionic-security main'>> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu bionic-security main'>> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu bionic-security universe'>> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/ubuntu bionic-security universe'>> /etc/apt/sources.list && \
    # change pip repository to tuna
    echo "[global]" > /etc/pip.conf && \
    echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >> /etc/pip.conf && \
    echo "[install]" >> /etc/pip.conf && \
    echo "trusted-host = https://pypi.tuna.tsinghua.edu.cn" >> /etc/pip.conf && \
# [=====minimal-notebook=====]
# Install all OS dependencies for fully functional notebook server
    apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs-nox \
    vim-tiny \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    tzdata \
    unzip \
    nano \
    xfonts-utils \
    fontconfig \
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    # fix winfonts permissions
    chmod -R 755 /usr/share/fonts/winfonts/ && \
    cd /usr/share/fonts/winfonts/ && \
    mkfontscale  && \
    mkfontdir  && \
    fc-cache -fv

# ---- nbconvert dependencies ----
# install TexLive latest
# COPY texlive /tmp/texlive
ENV PATH=/usr/local/texlive/main/bin/x86_64-linux:$PATH
RUN cd /tmp &&\
    wget -O texlive.profile https://gitee.com/dennischan/CJupyterDocker/raw/master/cminimal-notebook/texlive/texlive.profile && \
    wget -O install-tl-unx.tar.gz https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -zxvf install-tl-unx.tar.gz && \
    rm -rf install-tl-unx.tar.gz && \
    mv install-tl-* install && \
    ./install/install-tl --profile=texlive.profile --repository=https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/ && \
    # or create links, ENV method recommend
    # ln -fs $(find /usr/local/texlive/main/bin/x86_64-linux/* -executable) /usr/local/bin/ && \
    # add some tex macro for jupyter export
    tlmgr install \
    tcolorbox \
    environ \
    trimspaces \
    adjustbox \
    collectbox \
    upquote \
    titling \
    ucs \
    enumitem && \
    rm -rf /tmp/* && \
    rm -rf /home/$NB_USER/.wget-hsts && \
    # delete texlive help & source file
    rm -rf /usr/local/texlive/main/texmf-dist/doc && \
    rm -rf /usr/local/texlive/main/texmf-dist/source

USER $NB_UID