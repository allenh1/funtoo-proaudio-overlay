# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/x4x/x4x-portage/media-sound/xmms2-scrobbler/xmms2-scrobbler-0.1.3.ebuild,v 1.2 2007/06/19 21:44:43 dangertools Exp $

inherit eutils

DESCRIPTION="XMMS2 AudioScrobbler client"
HOMEPAGE="http://code-monkey.de/pages/xmms2-scrobbler"
SRC_URI="http://exodus.xmms.se/~tilman/${P}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="|| ( 
			media-sound/xmms2
			media-sound/xmms2-git
		)
		>=dev-ruby/event-loop-0.2"
DEPEND="$RDEPEND dev-ruby/rake"

pkg_preinst() {
	local which_xmms2="xmms2"
	has_version media-sound/xmms2 2> /dev/null || which_xmms2="xmms2-git"
	if ! built_with_use media-sound/${which_xmms2} ruby ; then
		eerror "You didn't build xmms2 with the ruby USE-flag"
		die
	fi
}

src_install() {
	dodoc README
	dodoc COPYING
	dodoc AUTHORS
	rake DESTDIR=${D} PREFIX=/usr install || die
}

pkg_postinst() {
	einfo "xmms2-scrobbler will fail to start until you create a configfile"
	einfo ""
	einfo "echo -e 'user: foo' >> ~/.config/xmms2/clients/xmms2-scrobbler/config"
	einfo "echo -e 'password: bar' >> ~/.config/xmms2/clients/xmms2-scrobbler/config"
	einfo ""
	einfo "More info and configuration-options can be found in xmms2-scrobbler's README file"
}
