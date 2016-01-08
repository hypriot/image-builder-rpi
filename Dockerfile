FROM debian:jessie

RUN apt-get update && apt-get install -y \
    python-pip \
    build-essential \
    libncurses5-dev \
    tree \
    binfmt-support \
    qemu \
    qemu-user-static \
    debootstrap \
    kpartx \
    lvm2 \
    dosfstools \
    pigz \
    awscli \
    ruby \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN gem update --no-document --system && \
    gem install --no-document serverspec && \
    gem install --no-document bundler

COPY build.sh /build.sh

# build sd card image
CMD /build.sh
