FROM ubuntu

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -yqq --no-install-recommends \
    curl \
    php-cli \
    php-curl \
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

# Install Rancher CLI
ENV RANCHER_CLI_VERSION 0.6.2
RUN curl -fsSL \
    "https://github.com/rancher/cli/releases/download/v${RANCHER_CLI_VERSION}/rancher-linux-amd64-v${RANCHER_CLI_VERSION}.tar.gz" \
    | tar xz \
    && mv rancher-v${RANCHER_CLI_VERSION}/rancher /usr/local/bin/rancher \
    && rm -rf rancher-v${RANCHER_CLI_VERSION}

COPY *.sh /

RUN useradd -ms /bin/bash runner
ENV HOME /home/runner
VOLUME ["/builds"]

ENTRYPOINT ["/bootstrap.sh"]
