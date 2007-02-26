# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Aldrin is an open source modular sequencer/tracker, compatible to
Buzz"
HOMEPAGE="http://trac.zeitherrschaft.org/aldrin/"

ESVN_REPO_URI="http://svn.zeitherrschaft.org/aldrin/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="dev-python/wxpython
	dev-python/ctypes
	=media-libs/libzzub-9999"
DEPEND="${RDEPEND}
	dev-util/scons"

src_install() {
	scons PREFIX=/usr DESTDIR="${D}" install || die "install failed"
	dodoc CREDITS ChangeLog
	# fix FDO entry
	sed -i -e "s:AudioVideo;:AudioVideo;Audio;Sequencer;:" \
		"${D}/usr/share/applications/${PN}.desktop"
}
