# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/frinika/frinika-0.1.7.ebuild,v 1.1 2006/04/10 10:04:59 gimpel Exp $

RESTRICT="mirror"
inherit eutils java-pkg-2

DESCRIPTION="Frinika is a free, complete music workstation software"
HOMEPAGE="http://www.frinika.com"
SRC_URI="mirror://sourceforge/frinika/${P}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=">=virtual/jre-1.5"

src_compile() {
	einfo "This is a binary package... no compilation needed"
}

src_install() {
	insinto /usr/lib/"${PN}"
	doins "${DISTDIR}"/"${P}".jar
	dosym /usr/lib/"${PN}"/"${P}".jar /usr/lib/"${PN}"/"${PN}".jar
	dobin "${FILESDIR}"/frinika
	make_desktop_entry "Frinika"
}
