Replica.one Requirements
========================

## Dependencies

The Replica.one build system depends on the following software:

* [GNU make](https://www.gnu.org/software/make/) v1 or later
* [GNU m4](https://www.gnu.org/software/m4/) v1.4 or later
* [Docker](https://docs.docker.com/get-docker/) v18.09 or later

The following software is recommended in order to achieve the optimal workflow with the Replica.one project:

* [Git](https://git-scm.com/) v1.6.5 or later

The build system requires Docker to be installed and properly configured on the host system. Replica.one leverages the [BuildKit engine](https://github.com/moby/buildkit) which is available in Docker v18.09 or higher.

## Installation

### Gentoo

```
emerge -av sys-devel/make app-emulation/docker sys-devel/m4 dev-vcs/git
```

### Arch Linux

```
pacman -S make docker m4 git
```

### Ubuntu 20.04 LTS (Focal Fossa)

```
apt-get install make docker.io m4 git
```

### Debian 11 (Bullseye)

```
apt-get install make docker.io m4 git
```
