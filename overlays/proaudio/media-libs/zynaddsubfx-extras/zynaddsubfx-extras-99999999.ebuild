# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit zyn3 fetch-tools unpacker
RESTRICT="mirror"
MY_P="unsorted_${PN/-extras/}Parameters_${PV}"
MY_PN="zynaddsubfx"
DESCRIPTION="unsorted bank/instruments and parameters for zynaddsubfx"
HOMEPAGE="http://zynaddsubfx.sourceforge.net"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE=""
DEPEND="${RDEPEND}
	app-arch/unzip"
RDEPEND="|| ( >=media-sound/zynaddsubfx-2.2.1-r4 media-sound/yoshimi )"

S="${WORKDIR}/"*zynaddsubfx*
src_unpack(){
	url=$(smart_source "http://zynaddsubfx.sourceforge.net/doc/instruments/" "unsorted")
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
	echo here i am

	# do a stupid workaround for unpacker
	ln -s "${PORTAGE_ACTUAL_DISTDIR}/${url##*/}"  "../distdir/${url##*/}"
	unpacker "${url##*/}"

	cd "${WORKDIR}/"*zynaddsubfx*
	find -name 'CVS' -exec rm -rf {} \; &>/dev/null
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	cd "${WORKDIR}/"*zynaddsubfx*
	unsorted="/usr/share/${MY_PN}/banks/unsorted"
	examples="/usr/share/${MY_PN}/examples"
	dodir   "${unsorted}" "${examples}"
	for dir in `find -maxdepth 1 -type d`;do
		mv "${dir}"/*.xiz "${D}${unsorted}" &>/dev/null
		echo mv "${dir}"/*.xiz "${D}${unsorted}"
	done
	#fowners -R root:root  "${unsorted}"
	#fperms -R 644 "${unsorted}"

	insinto "${examples}"
	doins -r ../*zynaddsubfx*
}

pkg_postinst() {
	einfo "This packages provides unsorted bank/instruments for zynaddsubfx in:"
	einfo "${unsorted}"
	einfo "and also  a lot of unsorted *.xmz parameters in:"
	einfo "${examples}"
}
