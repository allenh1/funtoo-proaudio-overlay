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

# use like normal sed but set environment to C
# also tries to verify if changes take place and
# call die it fails
# this function is not ready!!!! DO NOT USE
esed_check() {
	for i in $@;do
		eerror supermach $i
		find |grep "$i" &>/dev/null
		
		if [ $? == "0" ] && [ -e $i ];then
	#		
#if [ -z ${i##*/\var\/tmp\/portage*} ] || [ ! -z "`echo $i |grep -v ^\/`" ] \
#				|| [ -z "`echo $i |grep  ^\.\.`" ];then
			echo lol
			cp -a $i ${i}_tmp
			einfo "[Patching] $i"
#			fi
		fi
	done
	#set -x
	args=($@)
	LC_ALL=C sed ''${args[@]}''
	
	# cmp if changes occured
	for i in $@;do
		if [ -e $i ];then
			diff --brief -u $i ${i}_tmp &>/dev/null && die "sed failed within $i"
			rm -f ${i}_tmp
		fi
	done
}
