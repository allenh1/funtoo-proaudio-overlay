# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils base git-r3

DESCRIPTION="XMMS2 AudioScrobbler client"
HOMEPAGE="http://code-monkey.de/pages/xmms2-scrobbler"
#SRC_URI="ftp://ftp.code-monkey.de/pub/${PN}/${P}.tar.gz"

EGIT_REPO_URI="git://git.xmms.se/xmms2/xmms2-scrobbler.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-sound/xmms2
	net-misc/curl"
DEPEND="${RDEPEND}"

DOCS="README AUTHORS"

src_compile() {
	emake || die
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install || die
	dodoc ${DOCS}
}

pkg_postinst() {
	einfo "xmms2-scrobbler will fail to start until you create a configfile"
	einfo ""
	einfo "echo -e 'user: foo' >> ~/.config/xmms2/clients/xmms2-scrobbler/config"
	einfo "echo -e 'password: bar' >> ~/.config/xmms2/clients/xmms2-scrobbler/config"
	einfo ""
	einfo "More info and configuration-options can be found in xmms2-scrobbler's README file"
}
