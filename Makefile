default: build

build:
	docker build -t image-builder-rpi .

sd-image: build
	docker run --rm --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION image-builder-rpi

shell: build
	docker run -ti --privileged -v $(shell pwd):/workspace -v /boot:/boot -v /lib/modules:/lib/modules -e VERSION image-builder-rpi bash

tag:
	git tag ${TAG}
	git push origin ${TAG}
