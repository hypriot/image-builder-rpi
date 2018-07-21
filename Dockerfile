FROM hypriot/image-builder:latest

RUN set -euxo pipefail; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        binfmt-support \
        qemu \
        qemu-user-static; \
    rm -rf /var/lib/apt/lists/*

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
