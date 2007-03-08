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
# DEPRICATED: use has_version instead
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
# syntax: has_all-pkg "<category/pkgname_0> <category/pkgname_n>"
has_all-pkg() {
	local retval="0"
	for p in ${@};do
		if ! ( has_version "$p" && [ "$retval" == "0" ] );then
			return "1"
		fi
	done
	return "$retval"
}

# returns true if one of the given pkg is installed or false if none
# syntax: has_any-pkg "<category/pkgname_0> <category/pkgname_n>"
has_any-pkg() {
	for p in ${@};do
		has_version "$p" && return 0
	done
	return "1"
}

# use like normal sed but set environment to C
esed() {
	LC_ALL=C sed "$@"
}

# using sed and test if sed changed the file
# WARNING: it's only tested to work if it's called inside the
# dir which contains the file to patch
# syntax same as sed
esed_check() {
#	set -x
	local cnt=0
	local args=("$@")
	for i in ${args[@]};do
		if [ "$i" == "-i" ];then
			args[$cnt]="-iesed_bac"
		fi
		let "cnt+=1"
	done
	LC_ALL=C sed "${args[@]}"
	
	local backup=`find -name '*esed_bac' -printf '%f\n'`
	einfo "patching: ${backup/esed_bac/}  (using sed)"
	if diff --brief ${backup/esed_bac/} $backup &>/dev/null;then
		eerror "failed to patch: ${backup/esed_bac/}"
		eerror "Sed argument:"
		eerror "sed ${args[@]}"
		die "patching failed"
	fi
	rm -f $backup
}
