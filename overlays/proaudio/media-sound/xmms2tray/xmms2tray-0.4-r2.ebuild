# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

# Nonofficial ebuild by dangertools

inherit eutils python

DESCRIPTION="XMMS2tray - systray integration for XMMS2"
HOMEPAGE="http://zombiehq.jollybox.de/zhq/static/view/projects/xmms2tray"
SRC_URI="http://zombiehq.jollybox.de/xmms2tray/xmms2tray-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"
RDEPEND=">=dev-lang/python-2.4.3
	|| (
		>=media-sound/xmms2-0.2.8_rc2
		>=media-sound/xmms2-git-20070325 )
	>=dev-python/pygtk-2.10.3
	>=dev-python/notify-python-0.1.1"
DEPEND="${RDEPEND}"

src_unpack () {
	unpack ${A}
}

src_compile() {
	local which_xmms2="xmms2"
	has_version media-sound/xmms2 2> /dev/null || which_xmms2="xmms2-git"
	if ! built_with_use media-sound/${which_xmms2} python ; then
		eerror "You didn't build xmms2 with the python USE-flag"
		die
	fi
}

src_install() {
	python setup.py install --prefix=${D}/usr || die "Failed to create image"
	dodoc COPYING README PKG-INFO ChangeLog

	insinto /usr/share/pixmaps
	newins data/xmms2_64.png xmms2tray.png

	make_desktop_entry xmms2tray "XMMS2tray" xmms2tray.png "gtk+;AudioVideo" "/usr/share/xmms2tray" "Multimedia"
}
