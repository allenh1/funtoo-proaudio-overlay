# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: evermind
# Purpose: unpack everything no matter where it comes from


# adjusted unpack() version from ebuild.sh 4048 2006-07-29 18:20:13Z zmedico


# syntax:
# unpacker "archive_1" "archive_2" archive_n"
# to set the location to where the unpack action should take place
# specify UNPACK_DESTDIR in your ebuild (missing dirs will be created)
unpacker() {
	local x
	local y
	local myfail
	local tarvars

	if [ "$USERLAND" == "BSD" ]; then
		tarvars=""
	else
		tarvars="--no-same-owner"
	fi

	[ -z "$*" ] && die "Nothing passed to the 'unpack' command"

	for x in "$@"; do
		# default unpack path to ${WORKDIR}
		[ -z "${UNPACK_DESTDIR}" ] && UNPACK_DESTDIR="${WORKDIR}"
		vecho ">>> Unpacking ${x} to ${UNPACK_DESTDIR}"
		y=${x%.*}
		y=${y##*.}

		myfail="${x} does not exist"
		if [ "${x:0:2}" = "./" ] ; then
			srcdir=""
		else
			srcdir="${DISTDIR}/"
		fi
		
		z="${x##*/}"
		
		[ "${x}" == "${z}" ] && local cur_path="`pwd`/"
		[ ! -s "${srcdir}${z}" ] && ln -s ${cur_path}${x} "${srcdir}${z}"
		#eerror "ln -s ${lol}${x} "${srcdir}${z}""
		[[ ${x} == ${DISTDIR}* ]] && \
			die "Arguments to unpack() should not begin with \${DISTDIR}."
		[ ! -s "${srcdir}${z}" ] && die "$myfail"


		[ ! -e "${UNPACK_DESTDIR}" ] && [ ! -z "${UNPACK_DESTDIR}" ] && \
			mkdir -p "${UNPACK_DESTDIR}" 
		[ -e "${UNPACK_DESTDIR}" ] && [ ! -z "${UNPACK_DESTDIR}" ] && \
			cd "${UNPACK_DESTDIR}"
		
		myfail="failure unpacking ${x}"
		case "${x##*.}" in
			tar|h2drumkit)
				tar xf "${srcdir}${z}" ${tarvars} || die "$myfail"
				;;
			tgz)
				tar xzf "${srcdir}${z}" ${tarvars} || die "$myfail"
				;;
			tbz|tbz2)
				bzip2 -dc "${srcdir}${z}" | tar xf - ${tarvars}
				assert "$myfail"
				;;
			ZIP|zip|jar)
				unzip -qo "${srcdir}${z}" || die "$myfail"
				;;
			gz|Z|z)
				if [ "${y}" == "tar" ]; then
					tar zxf "${srcdir}${z}" ${tarvars} || die "$myfail"
				else
					gzip -dc "${srcdir}${z}" > ${x%.*} || die "$myfail"
				fi
				;;
			bz2|bz)
				if [ "${y}" == "tar" ]; then
					bzip2 -dc "${srcdir}${z}" | tar xf - ${tarvars}
					assert "$myfail"
				else
					bzip2 -dc "${srcdir}${z}" > ${x%.*} || die "$myfail"
				fi
				;;
			7Z|7z)
				local my_output
				my_output="$(7z x -y "${srcdir}/${z}")"
				if [ $? -ne 0 ]; then
					echo "${my_output}" >&2
					die "$myfail"
				fi
				;;
			RAR|rar)
				unrar x -idq "${srcdir}/${z}" || die "$myfail"
				;;
			LHa|LHA|lha|lzh)
				lha xqf "${srcdir}/${z}" || die "$myfail"
				;;
			a|deb)
				ar x "${srcdir}/${z}" || die "$myfail"
				;;
			*)
				vecho "unpack ${x}: file format not recognized. Ignoring."
				;;
		esac
		chmod -Rf a+rX,u+w,g-w,o-w .
		cd - &>/dev/null
	done

}
