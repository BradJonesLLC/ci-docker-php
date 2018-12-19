FROM php:7.2-cli-stretch

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -yqq --no-install-recommends \
    ca-certificates \
    git \
    wget \
    zip unzip \
    jq \
    patch \
    expect \
    tcl8.6 \
    && rm -rf /var/lib/apt/lists/*

ENV DOCKER_VERSION 17.04.0-ce
RUN curl -fsSL \
    "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-${DOCKER_VERSION}.tgz" | tar xz > docker \
    && mv docker/docker /usr/local/bin/docker \
    && rm -rf docker

# Install composer.
RUN php -r "readfile('https://getcomposer.org/installer');" | php && mv composer.phar /usr/local/bin/composer

# Install klar.
ENV KLAR_VERSION 2.3.0
RUN curl -o /usr/local/bin/klar -L https://github.com/optiopay/klar/releases/download/v$KLAR_VERSION/klar-$KLAR_VERSION-linux-amd64 \
    && chmod +x /usr/local/bin/klar

# Install Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY *.sh /

RUN useradd -u 2000 -mr runner
ENV HOME /home/runner

VOLUME ["/builds"]

ENTRYPOINT ["/bootstrap.sh"]
