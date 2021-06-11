# SPDX-License-Identifier: MIT
#
# Copyright (c) 2021 Sartura Ltd.
#

# Local variables
#
ENVFILE=/run/environment
REPODIR=/var/db/repos/gentoo
TCECLASS=${REPODIR}/eclass/toolchain-funcs.eclass

J=$(grep -c ^processor /proc/cpuinfo)

# Inherit and export current dynamic environment
#
if [[ -f ${ENVFILE} ]]; then
	set -a
	source ${ENVFILE}
	set +a
fi

# Sane defaults if dynamic variables are not set
#
[[ -z ${MAKEOPTS} ]] && MAKEOPTS="--jobs=${J}"
[[ -z ${EMERGE_DEFAULT_OPTS} ]] && EMERGE_DEFAULT_OPTS="--jobs=${J}"

# Additional helper variables
#
if [[ -n ${CTARGET} ]]; then
	TPARCH=$(inherit() { :; }; source ${TCECLASS}; tc-arch)
	TKARCH=$(inherit() { :; }; source ${TCECLASS}; tc-arch-kernel)
fi

# Additional helper functions
#
die() {
	echo
	echo -e "error: ${1}" >&2
	exit 1
}
check_rootportage_dir() {
	if [[ ! -d "${1}/etc/portage" ]]; then
		return 1
	fi

	return 0
}
check_repo_dir() {
	if [[ ! -d "${1}" || ! -d "${1}/metadata" ]]; then
		return 1
	fi

	return 0
}
set_repository_conf() {
	local ROOTDIR="${1%/}"
	local REPO="${2%/}"
	local PRIORITY="${3}"
	local CONFDIR="${ROOTDIR}/etc/portage/repos.conf"

	# is repo relative?
	[[ "${REPO}" == "${REPO#/}" ]] && REPO="/var/db/repos/${REPO}"
	local REPONAME="$(basename ${REPO})"

	# sanity check
	check_rootportage_dir "${ROOTDIR}" || die "${FUNCNAME[0]}: invalid portage dir"
	check_repo_dir "${REPO}"           || die "${FUNCNAME[0]}: invalid repo dir"
	[[ -d ${CONFDIR} ]] || die "${FUNCNAME[0]}: invalid conf dir"

	# create file
	printf '[%s]\nlocation = %s' "${REPONAME}" "${REPO}" > ${CONFDIR}/${REPONAME}.conf \
		|| die "${FUNCNAME[0]}"

	# priority is a signed integer
	if [[ "${PRIORITY}" =~ ^-?[0-9]+$ ]]; then
		printf '\npriority = %s' "${PRIORITY}" >> ${CONFDIR}/${REPONAME}.conf \
			|| die "${FUNCNAME[0]}"
	fi

	return 0
}
set_portage_profile() {
	local ROOTDIR="${1%/}"
	local REPO="${2%/}"
	local PROFILE="${3}"

	# is repo relative?
	[[ "${REPO}" == "${REPO#/}" ]] && REPO=/var/db/repos/${REPO}

	# sanity check
	check_rootportage_dir "${ROOTDIR}" || die "${FUNCNAME[0]}: invalid portage dir"
	check_repo_dir "${REPO}"           || die "${FUNCNAME[0]}: invalid repo dir"
	[[ -d "${REPO}/profiles/${PROFILE}" ]] || die "${FUNCNAME[0]}: invalid profile dir"

	# replace profile
	rm ${ROOTDIR}/etc/portage/make.profile || die "${FUNCNAME[0]}"
	ln -s ${REPO}/profiles/${PROFILE} ${ROOTDIR}/etc/portage/make.profile \
		|| die "${FUNCNAME[0]}"

	return 0
}

# Export local environment
#
export MAKEOPTS EMERGE_DEFAULT_OPTS TPARCH TKARCH
