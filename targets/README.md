replica/targets
===============

This directory is part of the Replica.one build system. The directory contains target definitions and packaging infrastructure.

## Targets

Consult [the official wiki](https://github.com/sartura/replica/wiki) for more information about the supported target devices. Other supported targets are:

**Generic package** (`package`) — builds a generic Gentoo package

**System** (`system`) — used internally by the build system

**Toolchain target** (`toolchain`) — generates Gentoo toolchain packages (gcc, libc, etc.)

**vmlinux** (`vmlinux`) — generates `vmlinux.h` for use with [BPF CO-RE](https://facebookmicrosites.github.io/bpf/blog/2020/02/19/bpf-portability-and-co-re.html)
