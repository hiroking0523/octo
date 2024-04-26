FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04
SHELL ["bash", "-c"]

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /workdir

# 必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
    liblzma-dev python-openssl git vim less htop sudo zip unzip

# pyenvをインストールし、Python 3.10.1をセットアップ
ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ARG PYTHON_VERSION="3.10.1"

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION

# pipでインストール
COPY requirements.txt /workdir/
RUN pip install -U pip &&\
    pip install --no-cache-dir -r /workdir/requirements.txt && \
    pip install --upgrade flax && \
    pip install --upgrade "jax[cuda12_pip]==0.4.20" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html && \
    rm /workdir/requirements.txt
