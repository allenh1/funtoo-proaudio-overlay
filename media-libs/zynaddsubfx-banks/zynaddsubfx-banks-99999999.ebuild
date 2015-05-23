# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zyn3 fetch-tools
RESTRICT="mirror"
MY_P="${P/zynaddsubfx-/}"
MY_P="${MY_P/-/}"
DESCRIPTION="ZynAddSubFX banks/instruments"
HOMEPAGE="http://zynaddsubfx.sourceforge.net/doc/instruments/"
# tell the user to use the "smart" version of this ebuild
# which tries to fetch the latest source
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="|| ( !<media-sound/zynaddsubfx-2.2.1-r4 media-sound/yoshimi )"

S="${WORKDIR}/banks"
src_unpack(){
#set -x
	url=$(smart_source "http://zynaddsubfx.sourceforge.net/doc/instruments/" "banks")
	if [ "${#PORTAGE_ACTUAL_DISTDIR}" == "0" ];then
		PORTAGE_ACTUAL_DISTDIR="${DISTDIR}"
	fi
	cmp_remote_local_size "${url}" "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}"
	if [ "$?" == "1" ];then
		addwrite "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}"
		rm -f "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}"
	fi

	if [ ! -e "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}" ];then
			addwrite "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}"
			wget ${url} -P "${PORTAGE_ACTUAL_DISTDIR}" ||\
		             die "cannot fetch  ${url##*/}"
	fi
	unzip "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}" &>/dev/null
	mv $(ls |tail -n1) banks
	cd "${S}"
	find -name 'CVS' -exec rm -rf {} \; &>/dev/null
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	target="/usr/share/zynaddsubfx"
	insinto  "${target}"
	doins -r "${S}"
}

pkg_postinst() {
	einfo "This packages provides banks/instruments for zynaddsubfx"
	einfo "They are located in ${target}"
	einfo "wich is the default location where zynaddsubfx is looking"
	einfo "for banks/instruments"
	einfo "If you think you've created a nice instrument and want to"
	einfo "share. Send it to zynaddsubfx-user@lists.sourceforge.net or"
	einfo "stamm@flashmail.com"
}
