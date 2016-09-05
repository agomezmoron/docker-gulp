# SAM Web Docker image

## Table of Contents
  - [Requirements](#requirements)
  - [Docker build](#docker-build)
  - [Docker run](#docker-run)

## Requirements

You have to install [Docker](https://www.docker.com/) following the [installation steps](https://docs.docker.com/engine/installation/) (choose your OS).

## Docker Build

There are two options to build the image:

### Building the entire image

You can build the app from this directory running:

```
docker build -t agomezmoron/docker-gulp-angular .
```

### Pulling from Docker

You can pull the image from Docker:

```
docker pull agomezmoron/docker-gulp-angular
```

## Docker Run

Run the image with the following command:

```
docker run --privileged -v /YOUR/SOURCES/FOLDER:/src -p 90:8080  -e HOST_UID=$(id -u) -e HOST_GID=$(id -g) -e GULP_TASK="YOUR_GULP_TASK" --rm -t -i --net=host agomezmoron/docker-gulp-angular
```

### Notes

The second part of the command, **'&& docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null'**, is an optional one that deletes past images of the builds so the PC does not end up with several duplicated images. It can be removed without affecting the build.
