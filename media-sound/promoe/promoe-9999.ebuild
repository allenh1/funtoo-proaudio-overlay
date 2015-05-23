# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils qt4-r2 git-2 waf-utils

DESCRIPTION="WinAmp2 skinnable frontend for XMMS2"
HOMEPAGE="http://wiki.xmms2.xmms.se/wiki/Client:Promoe"

EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-qt/qtgui-4.2
	>=dev-qt/qtcore-4.2
	>=media-sound/xmms2-0.4[cxx]"
DEPEND="${RDEPEND}"

src_install() {
	dodoc AUTHORS README TODO
	newicon "data/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Promoe XMMS2 Client" "${PN}" "AudioVideo;Audio;Player"
	autotools-utils_src_install
}
