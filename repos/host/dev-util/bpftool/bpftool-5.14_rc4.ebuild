# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Author: Jakov Petrina <jakov.petrina@sartura.hr>

EAPI=7

inherit bash-completion-r1 estack eutils llvm toolchain-funcs prefix linux-info

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

DESCRIPTION="Tool for inspection and simple manipulation of eBPF programs and maps"
HOMEPAGE="https://kernel.org/"

LINUX_V="${PV:0:1}.x"
if [[ ${PV} == *_rc* ]] ; then
	LINUX_VER=${PV//_/-}
	LINUX_SOURCES="linux-${LINUX_VER}.tar.gz"
	SRC_URI="https://git.kernel.org/torvalds/t/${LINUX_SOURCES}"
elif [[ ${PV} == *.*.* ]] ; then
	# stable-release series
	LINUX_VER=$(ver_cut 1-2)
	LINUX_PATCH=patch-${PV}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
	LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
	SRC_URI=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE=""

RDEPEND="virtual/libelf"
# NOTE: update linux-headers to 5.14 afterwards
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-5.13"
BDEPEND="sys-devel/clang:=[llvm_targets_BPF(+)]"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/bpf/bpftool"

RESTRICT="test"

CONFIG_CHECK="~DEBUG_INFO_BTF"

llvm_pkg_setup() {
	# eclass version will die if no LLVM can be found which will break prefix
	# bootstrap
	:
}

src_unpack() {
	local paths=(
		tools/bpf kernel/bpf
		tools/{arch,build,include,lib,perf,scripts} {scripts,include,lib} "arch/*/lib"
	)

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		filterdiff -p1 ${paths[@]/#/-i } -z "${DISTDIR}"/${LINUX_PATCH} \
			> ${P}.patch
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

	local a
	for a in ${A}; do
		[[ ${a} == ${LINUX_SOURCES} ]] && continue
		[[ ${a} == ${LINUX_PATCH} ]] && continue
		unpack ${a}
	done
}

src_prepare() {
	default

	if [[ -n ${LINUX_PATCH} ]] ; then
		pushd "${S_K}" >/dev/null || die
		eapply "${WORKDIR}"/${P}.patch
		popd || die
	fi

	# Avoid the call to `make kernelversion`
	echo "#define PERF_VERSION \"${MY_PV}\"" > ../perf/PERF-VERSION-FILE

	# The code likes to compile local assembly files which lack ELF markings.
	find -name '*.S' -exec sed -i '$a.section .note.GNU-stack,"",%progbits' {} +
}

bpftool_make() {
	local arch=$(tc-arch-kernel)

	emake V=1 VF=1 \
		HOSTCC="$(tc-getBUILD_CC)" HOSTLD="$(tc-getBUILD_LD)" PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" AR="$(tc-getAR)" LD="$(tc-getLD)" NM="$(tc-getNM)" \
		EXTRA_CFLAGS="${CFLAGS}" ARCH="${arch}" BPFTOOL_VERSION="${MY_PV}" \
		prefix="${EPREFIX}/usr" \
		"$@"
}

src_compile() {
	bpftool_make -f Makefile
}

src_install() {
	bpftool_make -f Makefile install DESTDIR="${D}"
}
