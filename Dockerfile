FROM hypriot/image-builder:latest

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
