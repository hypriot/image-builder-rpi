FROM hypriot/image-builder:latest

RUN set -euxo pipefail; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y binfmt-support qemu qemu-user-static --no-install-recommends; \
    rm -rf /var/lib/apt/lists/*

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
