Replica.one Output
==================

## Introduction

The `output/` directory contains the build artifacts generated after the successful completion of a target build.

## Targets

Supported targets and their respective build process place the final files in the `output/` directory:

**Generic package** (`package`)
* `<package>-<version>.tar.bz2` — [Portage binary package](https://wiki.gentoo.org/wiki/Binary_package_guide)

**System** (`system`)
* This target creates "checkpoint" Docker images (e.g: `replica/system:latest`) for debugging purposes.

**Toolchain target** (`toolchain`)
* `<toolchain>/<package>-<version>.tar.bz2` — Portage binary packages of the generated cross-toolchain, for debugging or development purposes

**vmlinux** (`vmlinux`)
* `<architecture>-vmlinux.h` — [bpftool](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/bpf/bpftool)-generated BTF information of an architecture-specific Linux `vmlinux` binary
* `<architecture>-vmlinux.elf.xz` — architecture-specific `vmlinux` binary used to generate BTF information

To learn more about other supported targets, consult [the official wiki](https://github.com/sartura/replica/wiki).
