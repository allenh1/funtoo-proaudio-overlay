# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
inherit eutils java-pkg-2

MY_P=frinika-0.6.0-${PV}
DESCRIPTION="Frinika is a free, complete music workstation software"
HOMEPAGE="http://www.frinika.com"
SRC_URI="mirror://sourceforge/frinika/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"/"${P}"

IUSE=""
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.5"

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	insinto /usr/lib/"${PN}"
	doins "${PN}".jar
	dobin "${FILESDIR}"/frinika
	insinto /usr/lib/"${PN}"/lib
	doins "${WORKDIR}"/lib/*
#	newicon "src/icons/frinika-icon1.png" "${PN}.png"
	make_desktop_entry "Frinika" ${PN} ${PN} "AudioVideo;Audio;Sequencer;"
}
