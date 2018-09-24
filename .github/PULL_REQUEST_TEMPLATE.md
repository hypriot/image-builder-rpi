Thanks for opening a pull request! In this repository, opening a PR will initiate the generation of a new Raspberry Pi image, and create an image file you can download and use in your Raspberry Pi.

The changes you add to the pull request, such as adding software to install, will be run on the generated image.

For an example, see the software installed and configured in this pull request: https://github.com/publiclab/image-builder-rpi/pull/15/files

### Recipe

Use this space to describe what your "recipe" is intended to install and configure on a Raspberry Pi:




****

### Download instructions

Generating the image will take a few minutes. Once the image is prepared, and if it succeeded, you'll see a green checkmark at the bottom of the pull request. To download the image:

1. click the green checkmark; you'll go to a page at a URL like `https://gitlab.com/publiclab/image-builder-rpi/pipelines/########/builds`
2. On this page, click the `Jobs` tab, next to `Pipeline`
3. Click the green `Passed` button
4. Click `Download` in the right-hand sidebar
5. Unzip the `artifacts.zip` file, and also the `hypriotos-rpi-camera_web.img.zip` within it
6. Use a program like https://etcher.io/ to flash it to an SD card

You'll also be able to read the output of the image generation in this window.

We hope to create a bot to report back the completed image URL in each pull request. If you can help create such a bot, please contact us at:

https://github.com/publiclab/image-builder-rpi/issues/16

Thanks!
