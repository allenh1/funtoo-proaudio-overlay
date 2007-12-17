# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils multilib toolchain-funcs

#="${WORKDIR}/stops-${PV}"

DESCRIPTION="Organ stops for aeolus by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/aeolus.html"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND=""

src_install() {
	dodir /usr/share/${PN}/waves
	fowners root:audio /usr/share/${PN}/waves
	fperms 774 /usr/share/${PN}/waves
	cp -R Aeolus* ${D}/usr/share/${PN}
	insinto /usr/share/${PN}
	doins *.ae0
}

pkg_postinst() {
	ewarn ""
	ewarn "Note: the directory /usr/share/${PN}/waves is set writeable for"
	ewarn "the audio group, so Aeolus works correctly. Please make sure your"
	ewarn "user running Aeolus is in the audio group."
	ewarn ""
}

