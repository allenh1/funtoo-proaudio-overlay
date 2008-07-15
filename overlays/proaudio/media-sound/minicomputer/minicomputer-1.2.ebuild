# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${PN/mini/Mini}V${PV}"

DESCRIPTION="Standalone Linux softwaresynthesizer"
HOMEPAGE="http://minicomputer.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

# poor gentoo mirrors
RESTRICT="nomirror"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	x11-libs/fltk
	media-libs/alsa-lib
	media-libs/liblo"
DEPEND="${RDEPEND}
	dev-util/scons"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-fltk.patch"
}

src_compile() {
	scons PREFIX=/usr || die
}

src_install() {
	dobin minicomputer minicomputerCPU
	doicon minicomputer.xpm
	dodoc CHANGES README
	make_desktop_entry "${PN}" "Minicomputer" "${PN}" "AudioVideo;Audio"

	# install presets
	insinto /usr/share/${PN}
	doins -r factoryPresets
}

pkg_postinst() {
	elog "The presets can be found in /usr/share/${PN}"
	elog "Just copy them to ~/.miniComputer/"
}
