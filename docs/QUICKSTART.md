Replica.one Quick Start
=======================

## Cloning the repository

Recursively clone the main Replica.one repository using Git:

```
~ $ git clone --recursive https://github.com/sartura/replica.git
~ $ cd replica
```

## Building firmware

The following `make` targets are available for targets in the `targets/` directory:

* `build_<target>`
* `package_<target>`

where `<target>` is a target name represented by a corresponding `targets/<target>.docker` file.

To run a build execute the following command:

```
~ $ make DOCKER_BUILDKIT=1 CTARGET=<tuple> package_<target>
```

where `<tuple>` is a [short string describing the toolchain and system combination](https://wiki.gentoo.org/wiki/Embedded_Handbook/Tuples). The following tuples are currently supported:

* `armv7a-unknown-linux-gnueabihf`
* `aarch64-unknown-linux-gnu`
* `x86_64-multilib-linux-gnu`
* `armv7a-unknown-linux-musleabihf`
* `aarch64-unknown-linux-musl`
* `x86_64-multilib-linux-musl`

## Supported targets

A list of currently supported targets and additional instructions for hardware preparation are available in the [`../targets/README.md` document](../targets/README.md).
