# Maintainer's Guide

This document explains how to maintain an image-builder repo.

## How it works

The SD card is automatically built with [Travis](https://travis-ci.org).
You don't need real hardware to build and publish the SD card image.

### Pull requests

Pull requests are also built and checked with Travis.
See the `.travis.yml` file which commands are run for each Git commit.
The tests defined in `builder/test/` check the SD card image for each Git
commit and before releasing a new SD card image.

## Draft a new release

You can create a new release directly on GitHub.

Just click on "releases", then click the "Draft a new release" button.
Please check that you draft a release on "master" branch.

Type in eg. "v1.0.0" into the "Tag version" input field.

Type in eg. "v1.0.0" into the "Release title" input field.

Type in a release description. You may use the text of the previous release
and adjust it. A release description is important for users of
[Sibbell](https://sibbell.com) to receive a good notification email or Slack
message.

You can decide if it's a pre-release with the checkbox at the bottom.

Then press "Publish release".

After that Travis starts a new tagged build with that version tag and also
runs the deploy steps defined in `.travis.yml` and pushes the SD card image
to the GitHub release.
