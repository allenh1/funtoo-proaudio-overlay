# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs subversion

MY_P="${PN/mini/Mini}V${PV}"

DESCRIPTION="Standalone Linux softwaresynthesizer"
HOMEPAGE="http://minicomputer.sourceforge.net"
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
ESVN_REPO_URI="https://minicomputer.svn.sourceforge.net/svnroot/minicomputer/trunk"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	>=x11-libs/fltk-1.1.7:1.1[threads]
	media-libs/alsa-lib
	media-libs/liblo"
DEPEND="${RDEPEND}
	dev-util/scons"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fltk.patch"
	epatch "${FILESDIR}/${P}-respect-tc-flags.patch"
}

src_compile() {
	tc-export CC CXX
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
