# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="@dennischancs/CJupyterDocker"

USER root
# add `-u root` login jupyter
COPY start.sh /usr/local/bin/
# Copy local files as late as possible to avoid cache busting
COPY jupyter_notebook_config.py /etc/jupyter/

# --- jupyter export PDF use TexLive Chinese Templates ----
# '--chown=' is losing portability, hub.docker.com can success(Version: 19+), but cloud.tencent.com & cloud.aliyun.com may fail(Version: 17.06.1-ce)
# for hub.docker.com
COPY --chown=$NB_UID:$NB_GID latex $CONDA_DIR/lib/python3.7/site-packages/nbconvert/templates/latex
# # for cloud.tencent.com & cloud.aliyun.com
# COPY latex $CONDA_DIR/lib/python3.7/site-packages/nbconvert/templates/latex
# RUN fix-permissions $CONDA_DIR/lib/python3.7/site-packages/nbconvert/templates/latex
# ---

USER $NB_UID
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
# install TinyTeX
ENV PATH=/root/.TinyTeX/bin/x86_64-linux:$PATH
RUN cd /tmp &&\
    wget -qO- "https://yihui.org/gh/tinytex/tools/install-unx.sh" | sh && \
    tlmgr install \
    tcolorbox \
    environ \
    trimspaces \
    adjustbox \
    collectbox \
    upquote \
    titling \
    ucs \
    enumitem \
    parskip \
    caption \
    pgf \
    eurosym \
    ulem \
    jknapltx && \
    rm -rf /tmp/*

USER $NB_UID