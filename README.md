# senzingsdk-tools

## Synopsis

A Docker image with Senzingsdk library and Senzing tools installed.

## Overview

The [senzing/senzingsdk-tools] Docker image is pre-installed with the Senzingsdk library
and python tools to help simplify creating applications that use the Senzingsdk library.

## Use

In your `Dockerfile`, set the base image to `senzing/senzingsdk-tools`.
Example:

```Dockerfile
FROM senzing/senzingsdk-tools
```

## License

View [license information] for the software container in this Docker image.
Note that this license does not permit further distribution.

This Docker image may also contain software from the [Senzing GitHub community]
under the [Apache License 2.0].

Further, as with all Docker images, this likely also contains other software which may
be under other licenses (such as Bash, etc. from the base distribution, along with any direct
or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that
any use of this image complies with any relevant licenses for all software contained within.

[Apache License 2.0]: https://www.apache.org/licenses/LICENSE-2.0
[license information]: https://senzing.com/end-user-license-agreement/
[Senzing GitHub community]: https://github.com/Senzing/
[senzing/senzingsdk-tools]: https://hub.docker.com/r/senzing/senzingsdk-tools
