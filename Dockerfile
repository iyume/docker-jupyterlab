FROM python:3.9.5-alpine

LABEL maintainer="iyume <iyumelive@gmail.com>"

ENV PIP_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple
ENV LANG=C.UTF-8

RUN set -eux \
    && apk add --update --virtual=.build-deps \
        alpine-sdk \
        nodejs \
        ca-certificates \
        musl-dev \
        python3-dev \
        wget \
        gcc \
        g++ \
        make \
        cmake \
        gfortran \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        zlib-dev \
        libxml2-dev \
        libxslt-dev \
        libffi-dev \
        openssl-dev \
        openblas-dev \
        openjpeg-dev \
        lcms2-dev \
        tiff-dev \
        tk-dev \
        tcl-dev \
        harfbuzz-dev \
        fribidi-dev \
        build-base \
        libzmq \
        zeromq-dev \
    && pip install --upgrade pip setuptools wheel \
    && pip install jupyter ipywidgets jupyterlab -i $PIP_MIRROR \
    && jupyter serverextension enable --py jupyterlab \
    && pip install numpy pandas matplotlib

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-i18n-2.23-r3.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk && \
    apk add --no-cache glibc-2.23-r3.apk glibc-bin-2.23-r3.apk glibc-i18n-2.23-r3.apk && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h

# Expose Jupyter port & cmd
EXPOSE 8888
RUN mkdir -p /opt/app/data
CMD jupyter lab --ip=* --port=8888 --no-browser --notebook-dir=/opt/app/data --allow-root
