FROM demoncat/onec-base:latest as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG TYPE=platform83

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ARG TYPE=platform83

ARG ONEGET_VER=v0.5.2
WORKDIR /tmp

RUN set -xe; \
  apt update; \
  apt install -y \ 
    curl \
    bash \
    pigz; \
    rm -rf /var/lib/apt/lists/*

RUN  cd /tmp; \
  curl -sL http://git.io/oneget.sh > oneget; \
  chmod +x oneget; \ 
  ./oneget --debug get  --extract --rename platform:linux.full.x64@$ONEC_VERSION; \
  cd /tmp/downloads/$TYPE/$ONEC_VERSION/server64.$ONEC_VERSION.tar.gz.extract; \ 
  ./setup-full-$ONEC_VERSION-x86_64.run --mode unattended  --enable-components ws,server_admin,server; \
  cd /tmp; \
  rm -rf downloads

COPY ./scripts/create_symlink.sh create_symlink.sh

RUN set -e \
  && chmod +x create_symlink.sh \
  && ./create_symlink.sh $ONEC_VERSION
