# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/jackmix/jackmix-0.1.ebuild,v 1.1.1.1 2006/04/10 11:38:12 gimpel Exp $

inherit eutils

MY_P="${PN}-${PV}.0-r1"

RESTRICT="nomirror"
IUSE=""

DESCRIPTION="a mixer app for jack"
HOMEPAGE="http://dillenburg.dyndns.org/~arnold/node/71"
SRC_URI="http://dillenburg.dyndns.org/~arnold/files/downloads/jackmix/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-sound/jack-audio-connection-kit
	=x11-libs/qt-3*
	dev-util/pkgconfig
	>=media-libs/liblo-0.23"

src_compile() {
	[ -d "$QTDIR/etc/settings" ] && addwrite "$QTDIR/etc/settings"
	addpredict "$QTDIR/etc/settings"

	econf  || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog
}
