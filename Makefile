default: build

VERSION := $(shell cat VERSION)
export VERSION

build:
	docker build -t image-builder-rpi .

sd-image: build
	docker run --rm --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION image-builder-rpi

shell: build
	docker run -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION image-builder-rpi bash

relese:
	git tag ${VERSION}
	git push origin ${VERSION}
