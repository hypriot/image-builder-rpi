FROM hypriot/image-builder:latest

RUN apt-get update && \
    apt-get remove -y binfmt-support && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    binfmt-support \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
