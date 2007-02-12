# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

#
# Original Author: evermind
# extend eutils eclass

# gives back 1 if useflag set, 0 if not
# syntax: usesflag "flag"
usesflag() {
	local retval="0"
	use "$1" && retval="1"
	echo "${retval}"
}

# returns true/false if pkg is installed or not
# syntax: is_pkg_installed <category/pkgname>
is_pkg_installed() {
	local missing_action="die"
	if [[ $1 == "--missing" ]] ; then
		missing_action=$2
		shift ; shift
		case ${missing_action} in
			true|false|die) ;;
			*) die "unknown action '${missing_action}'";;
		esac
	fi

	# check if package is installed
	local PKG=$(best_version $1)
	[[ -z ${PKG} ]] && return 1 || return 0
}

# returns true if all pkg are installed or false if not
# syntax: all_pkg_installed "<category/pkgname_0> <category/pkgname_n>"
all_pkg_installed() {
	local retval="0"
	for p in ${@};do
		if ! ( is_pkg_installed "$p" && [ "$retval" == "0" ] );then
			return "1"
		fi
	done
	return "$retval"
}

# returns true if one of the given pkg is installed or false if none
# syntax: all_pkg_installed "<category/pkgname_0> <category/pkgname_n>"
any_pkg_installed() {
	for p in ${@};do
		is_pkg_installed "$p" && return 0
	done
	return "1"
}
