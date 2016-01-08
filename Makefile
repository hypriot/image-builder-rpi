default: build

build:
	docker build -t image-builder-rpi .

sd-image: build
	docker run --rm --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules image-builder-rpi

shell: build
	docker run -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules image-builder-rpi bash
