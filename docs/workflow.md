# Development Workflow for Custom Images

We recommend that you follow these steps to build your images.

## Make a Pull Request

Create a named branch with a descriptive name (it will be used in the image filename), and **make a pull request** describing your intentions!

**Intention to merge to master is not required**. You may issue a PR simply for sharing an experiment and for triggering a build to test an image.

## Download the build artifact from GitLab CI

Once you've made a PR, you should see a build triggered that is linked in your PR.

It can take more than 20 minutes to build an image.

You may follow the link on your PR to view the build log and find the links to download the build artifacts, which hold the image for flashing.

These images are referred to as build artifacts and are available for download directly from the [**build jobs page at Gitlab**](https://gitlab.com/publiclab/image-builder-rpi/-/jobs).

## Flash your image

Using your preferred method (or the [Hypriot flash tool](https://github.com/hypriot/flash) which offers some flash-time customization hooks.

## Share your results!

Do comment on your PR!
