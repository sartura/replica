Replica.one Configuration
=========================

## Build configuration flags

The following `make` configuration flags are supported:

| **Variable**       | **Required** | **Value type** | **Default value** | **Description** |
| ---                | ---          | ---            | ---               | ---             |
| `CTARGET`          | **yes**      | String         | (user defined)    | Specify a tuple (https://wiki.gentoo.org/wiki/Embedded_Handbook/Tuples). |
| `V`                | no           | Integer        | `0`               | Controls the verbosity of the build system. |
| `J`                | no           | Integer        | number of cores   | Define the number of threads to use during compilation. |
| `L`                | no           | Integer        | (user defined)    | Specify the maximum system load to prevent CPU starvation. |
| `GENTOO_TAG`       | no           | String         | from Makefile     | Determine the `<date>` of the Gentoo Docker image to use as a base for the build system. |
| `GENTOO_MIRRORS`   | no           | String         | (user defined)    | Define the `<url(s)>` of the Gentoo mirrors to use to fetch package distfiles. |
| `CACHE_FROM`       | no           | String         | (user defined)    | Specify a local or remote Docker image from which to fetch the build cache. |
| `NO_CACHE`         | no           | Boolean        | `0`               | Set to `1` to force Docker not to use caching. |
| `USE_CCACHE`       | no           | Boolean        | `1`               | Set to `0` to disable compiler cache, which is enabled by default. |
| `KERNEL_REMOTE`    | no           | String         | (user defined)    | Force a specific kernel Git repository remote location. |
| `KERNEL_BRANCH`    | no           | String         | (user defined)    | Force a specific kernel Git repository branch. |
| `KERNEL_CONFIG`    | no           | String         | (user defined)    | Force a specific kernel configuration file. |
| `WITH_ROOTFS`      | no           | Boolean        | `0`               | Enable to package the target root filesystem as a compressed TAR archive in addition to generating the platform images. |
| `USE`              | no           | String         | (user defined)    | Force a specific `USE` combination for the `package` target. |
| `PACKAGE`          | **yes, for `package` target** | String | (user defined) | Determine which package to build for the `package` target. |

Few examples for illustrative purposes are shared below:

```
make GENTOO_MIRRORS="http://mirror.netcologne.de/gentoo/" PACKAGE="sys-apps/ethtool" package_package
```

```
make V=1 WITH_ROOTFS=1 NO_CACHE=1 GENTOO_TAG=20210522 CTARGET=aarch64-unknown-linux-gnu package_tn48m
```

```
make J=64 L=64 CTARGET=armv7a-unknown-linux-gnueabihf package_vmlinux
```

## Target configuration

Additional resources for removing and adding new packages are available on [the Gentoo Wiki](https://wiki.gentoo.org/).
