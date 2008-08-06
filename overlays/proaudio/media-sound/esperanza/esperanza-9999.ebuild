# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils toolchain-funcs git
EAPI=1


DESCRIPTION="Esperanza - a QT4 client for xmms2."
HOMEPAGE="http://xmms2.xmms.org"

EGIT_REPO_URI="git://git.xmms.se/xmms2/esperanza.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RESTRICT="nomirror"

RDEPEND="|| (
		>=media-sound/xmms2-0.2.8_rc2
		media-sound/xmms2-git )
	>=dev-libs/boost-1.32
	|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns )
		>=x11-libs/qt-4:4 )"

DEPEND=">=sys-devel/gcc-3.4
	!media-sound/esperanza-git
	${RDEPEND}"

src_compile() {
	local which_xmms2="xmms2"
	has_version media-sound/xmms2 2> /dev/null || which_xmms2="xmms2-git"
	if ! built_with_use media-sound/${which_xmms2} cpp ; then
		eerror "You didn't build xmms2 with the cpp USE-flag"
		die
	fi

	# econf and emake might not work..
	./configure --prefix=/usr || die "Configure failed"
	gmake || "die make failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die
	dodoc COPYING

	doicon data/images/esperanza.png
	make_desktop_entry ${PN} "Esperanza" ${PN} "Qt4;AudioVideo;Player"
}

