# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4 git

DESCRIPTION="WinAmp2 skinnable frontend for XMMS2"
HOMEPAGE="http://wiki.xmms2.xmms.se/wiki/Client:Promoe"

EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="|| ( >=x11-libs/qt-4.2.0 x11-libs/qt-gui:4.4 )
	>=media-sound/xmms2-0.4"
RDEPEND="${DEPEND}"

pkg_setup() {
	# no use-depends yet..
	if ! built_with_use media-sound/xmms2 cpp; then
		eerror "You need to compile media-sound/xmms2 with USE=cpp"
		die
	fi
}


src_compile() {
	eqmake4 || die
	emake || die
}

src_install() {
	dobin promoe
	dodoc AUTHORS README TODO
	newicon "data/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Promoe XMMS2 Client" "${PN}" "AudioVideo;Audio;Player"
}
