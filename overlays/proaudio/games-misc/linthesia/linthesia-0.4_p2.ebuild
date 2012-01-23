# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit games toolchain-funcs versionator

MY_SFVER="$(get_version_component_range 1-2)"
MY_PV=${PV/_p/-}

DESCRIPTION="A fork of Synthesia, A game of playing music! You only need a MIDI file to play, and a MIDI keyboard"
HOMEPAGE="http://linthesia.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/v${MY_SFVER}/${PN}-${MY_PV}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-cpp/gconfmm-2.6
	>=dev-cpp/gtkglextmm-1.2:1.0
	>=dev-cpp/gtkmm-2.4:2.4
	>=media-libs/alsa-lib-1.0.24.1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

PATCHES=(
# edit makefiles for gentoo
"${FILESDIR}/${P}-Makefiles.patch"
# patch taken from ubuntu fixes crash on start when loading midi file on 64-bit
"${FILESDIR}/${P}-wordsize-bugs.patch"
# fixes crash for font loading with pango
"${FILESDIR}/${P}-pango-font-loading.patch"
)

src_prepare() {
	base_src_prepare
	sed -i -e "s|/usr/share/linthesia|${GAMES_DATADIR}/${PN}|g" Makefile || die
}

src_compile() {
	GRAPHDIR="${GAMES_DATADIR}/${PN}/graphics" emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README

	insinto /usr/share/applications
	doins extra/${PN}.desktop

	insinto /usr/share/pixmaps
	doins extra/${PN}.xpm

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "The ${PN}-${MY_PV}.src.tgz source tarball contains several midi"
	einfo "files in the ${PN}/music/ sub-directory for practicing,"
	einfo "these were not installed due to the potential of copyright"
	einfo "infringment."
	einfo "Please manually unpack this directory to a suitable location if you"
	einfo "wish to use them with the application."
}
