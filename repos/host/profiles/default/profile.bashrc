# SPDX-License-Identifier: MIT
#
# Copyright (c) 2021 Sartura Ltd.
#

# NOTE: This maps additional CTARGETS due to long-standing Gentoo issue
# https://bugs.gentoo.org/651908
if [[ ${CATEGORY}/${PN} == sys-devel/clang && ${EBUILD_PHASE} == instprep ]]; then
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1 "${llvm_version}")
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local ctarget i

	# FIXME: Can we grab these from the eclass utils?
	local ctargets=(
		x86_64-multilib-linux-gnu
		aarch64-unknown-linux-gnu
		armv7a-unknown-linux-gnueabihf
	)

	for ctarget in "${ctargets[@]}"; do
		for i in "${clang_tools[@]}"; do
			ewarn "!!! Installing ${ctarget} symlinks..."

			dosym "${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${ctarget}-${i}-${clang_version}" || die
			dosym "${ctarget}-${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${ctarget}-${i}" || die
		done
	done
fi
