# Auna Core System

This repository contains the Core System of the Blockchain as a Service platform.
Please use the "pull request" feature when pushing to Master branch.

## Building the System

To build the local images, run:

```shell
make build-all
```

To build a single image:
```shell
make <project-name>-build
```

Examples:
```shell
make web-isv-admin-api-build
make web-isv-admin-app-build
```

To tag/push all the latest images:
```shell
make tag-all
```

To push the latest image to the registry:
```shell
make <project-name>-tag
```

Examples:
```shell
make web-isv-admin-api-tag
make web-isv-admin-app-tag
```