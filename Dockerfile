FROM ubuntu

RUN apt-get update && apt-get install -yqq --no-install-recommends \
    curl \
    php-cli \
    ca-certificates \
    git \
    wget \
    zip unzip \
    && apt-get clean autoclean && apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

ENV DOCKER_VERSION 17.04.0-ce
RUN curl -fsSL \
    "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-${DOCKER_VERSION}.tgz" | tar xz > docker \
    && mv docker/docker /usr/local/bin/docker \
    && rm -rf docker

# Install composer.
RUN php -r "readfile('https://getcomposer.org/installer');" | php && mv composer.phar /usr/local/bin/composer

COPY *.sh /

RUN useradd -ms /bin/bash runner
ENV HOME /home/runner
VOLUME ["/builds"]

ENTRYPOINT ["/bootstrap.sh"]
