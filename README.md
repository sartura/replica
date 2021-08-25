Replica.one
===========
[![Build Status](https://drone.sartura.hr/api/badges/sartura/replica/status.svg?ref=refs/heads/master)](https://drone.sartura.hr/sartura/replica)

Replica.one is an Open Source build system based on Gentoo with speed and flexibility in mind.

## Quick start

Quick start instructions are available in the [`./docs/QUICKSTART.md` document](./docs/QUICKSTART.md).

## Structure

The build system repository structure is as follows:

* `targets/` — target definitions and packaging.
* `repos/` — contains Portage [ebuild repositories (**overlays**)](https://wiki.gentoo.org/wiki/Ebuild_repository) in the form of Git submodules.
* `overlay/` — root-level directory containing additional files (usually config files) to install onto the target filesystem.
* `modules/` — generalized instructions, e.g., for building the kernel or configuring the target system.
* `config/` — contains various build-time configuration files.
* `output/` — will contain build artifacts upon successful build completion.

## Documentation

Consult [the official wiki](https://github.com/sartura/replica/wiki) to familiarize yourself with the process of building and flashing procedures for a particular device.

The [`./docs/CONFIGURATION.md` document](./docs/CONFIGURATION.md) describes the configuration options of the Replica.one build system.

Every directory contains a separate readme file with more information about the directory's function, except for the `output` directory documented in the [`./docs/OUTPUT.md` document](./docs/OUTPUT.md).

## Requirements

The Replica.one build system depends on the following software:

* [GNU make](https://www.gnu.org/software/make/)
* [GNU m4](https://www.gnu.org/software/m4/)
* [Docker](https://docs.docker.com/get-docker/)

Additional recommended software:

* [Git](https://git-scm.com/)

Consult the [`./docs/REQUIREMENTS.md` document](./docs/REQUIREMENTS.md) for more information regarding dependency version details and related instructions.

## Download

Download the precompiled firmware images from [here](https://drone.sartura.hr/artifacts/).

## License

[MIT](LICENSE)
