# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Nonofficial ebuild by dangertools $

EAPI=1

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Esperanza - a QT4 client for xmms2."
HOMEPAGE="http://xmms2.xmms.org"

SRC_URI="http://exodus.xmms.se/~tru/esperanza/0.4/esperanza-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE=""

RESTRICT="mirror"

RDEPEND="|| (
		>=media-sound/xmms2-0.2.8_rc2
		media-sound/xmms2-git )
	>=dev-libs/boost-1.32
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtxmlpatterns"

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

	doicon data/images/esperanza.png
	make_desktop_entry ${PN} "Esperanza" ${PN} "Qt4;AudioVideo;Player"
}
