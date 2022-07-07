# SPDX-License-Identifier: MIT
#
# Copyright (c) 2021-2022 Sartura Ltd.
#

# Command arguments
#
M4FLAGS :=
DBUILDOPTS :=
DRUNOPTS := --privileged --rm

envcache  := environment.cache
m4common  := modules/common.m4

# Verbosity
#
ifeq ($(V),1)
  M4FLAGS += --debug=aefilpqt
  DBUILDOPTS += --progress=plain
endif


# Detect the amount of available CPU cores
#
J ?= $(shell grep -c ^processor /proc/cpuinfo)
makeopts += --jobs=$(J)

ifneq ($(L),)
  makeopts += --load-average=$(L)
endif

# NOTE: `MAKEOPTS` and `EMERGE_DEFAULT_OPTS` together affect system performance
#       in a specific way. Please consult the Portage documentation for details.
# https://wiki.gentoo.org/wiki/EMERGE_DEFAULT_OPTS/en
M4FLAGS += -D__makeopts__="$(makeopts)"
M4FLAGS += -D__emergeopts__="$(makeopts)"


# Target architecture is represented by a tuple
#
# https://wiki.gentoo.org/wiki/Embedded_Handbook/Tuples
ifeq ($(CTARGET),)
  $(warning CTARGET is not set on the command line, assuming `x86_64`)
  DBUILDOPTS += --build-arg CTARGET="x86_64-multilib-linux-gnu"
  M4FLAGS += -D__CTARGET__="x86_64-multilib-linux-gnu"
else
  DBUILDOPTS += --build-arg CTARGET="${CTARGET}"
  M4FLAGS += -D__CTARGET__="$(CTARGET)"
endif

# Target distribution
#
ifneq ($(TARGET_DISTRO),)
  M4FLAGS += -D_TDISTRO_="$(TARGET_DISTRO)"
endif


# Build options and Docker setup
#
# NOTE: Docker will not otherwise include cache metadata into images!
# https://docs.docker.com/engine/reference/commandline/build/#specifying-external-cache-sources
DBUILDOPTS += --build-arg BUILDKIT_INLINE_CACHE=1
DBUILDOPTS += --secret id=env,src=$(envcache)

DOCKER_BUILDKIT := 1
export DOCKER_BUILDKIT

ifeq ($(GENTOO_TAG),)
  GENTOO_TAG := 20220707
endif

ifeq ($(NO_CACHE),1)
  DBUILDOPTS += --no-cache
endif

ifneq ($(CACHE_FROM),)
  DBUILDOPTS += --cache-from="$(CACHE_FROM)"
endif

ifneq ($(PACKAGE),)
  DBUILDOPTS += --build-arg PACKAGE="$(PACKAGE)"
endif

ifneq ($(USE),)
  DBUILDOPTS += --build-arg USE="$(USE)"
endif

ifneq ($(GENTOO_MIRRORS),)
  M4FLAGS += -D__mirrors__="$(GENTOO_MIRRORS)"
endif

ifneq ($(USE_CCACHE),0)
  M4FLAGS += -D_with_ccache_
endif

ifneq ($(KERNEL_REMOTE),)
  M4FLAGS += -D__kernel_remote__="$(KERNEL_REMOTE)"
endif
ifneq ($(KERNEL_BRANCH),)
  M4FLAGS += -D__kernel_branch__="$(KERNEL_BRANCH)"
endif
ifneq ($(KERNEL_CONFIG),)
  M4FLAGS += -D__kernel_config__="$(KERNEL_CONFIG)"
endif

ifneq ($(DEBOOTSTRAP_RELEASE),)
  M4FLAGS += -D__debootstrap_release__="$(DEBOOTSTRAP_RELEASE)"
endif
ifneq ($(DEBOOTSTRAP_URL),)
  M4FLAGS += -D__debootstrap_url__="$(DEBOOTSTRAP_URL)"
endif
ifneq ($(DDR_TOPOLOGY),)
  M4FLAGS += -D__atf_ddr_topology__="$(DDR_TOPOLOGY)"
endif

ifneq ($(WITH_ROOTFS),)
  DRUNOPTS += --env WITH_ROOTFS=1
endif

# Get GIT HEAD hash
# This is used to identify origin of the running device image
GIT_HASH := $(shell git rev-parse HEAD)
M4FLAGS += -D__git_hash__="$(GIT_HASH)"

# Always rebuild these targets
#
.PHONY = pull update clean $(envcache)

# Preprocessing, building, and packaging targets
#
$(envcache): environment.in $(m4common)
	@m4 $(m4common) $(M4FLAGS) $< > $@

targets/%.cache: targets/%.docker modules/*.docker $(m4common)
	@m4 $(m4common) $(M4FLAGS) -D_BTARGET_="$*" $< > $@

build_%: targets/%.cache $(envcache) pull
	docker build . -f targets/$*.cache $(DBUILDOPTS) --tag replica/$*:latest

package_%: build_%
	docker run $(DRUNOPTS) --volume ${PWD}/output:/output -- replica/$*:latest

# Additional targets
#
pull:
	docker pull gentoo/stage3:amd64-openrc-$(GENTOO_TAG)
	@docker tag gentoo/stage3:amd64-openrc-$(GENTOO_TAG) gentoo/stage3:replica

clean:
	rm -rf output/*
