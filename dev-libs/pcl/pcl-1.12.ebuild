# Copyright 1999-2011 Mat
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI="3"

inherit 

DESCRIPTION="Portable Coroutine Library (low level functionality for coroutines"
HOMEPAGE="http://xmailserver.org/libpcl.html"

SRC_URI="http://xmailserver.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR=${D} install || die "Install failed."
	dodoc AUTHORS || die
}
