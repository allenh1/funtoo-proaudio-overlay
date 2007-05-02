# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="JackMixDesk is an audio mixer for JACK with an OSC control
interface and LASH support"
HOMEPAGE="http://sourceforge.net/projects/jackmixdesk"
ESVN_REPO_URI="https://jackmixdesk.svn.sourceforge.net/svnroot/jackmixdesk/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lash"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100.0
		=x11-libs/gtk+-2*
		lash? ( media-sound/lash )
		media-libs/liblo
		media-libs/phat
		net-dns/libidn"
DEPEND="${RDEPEND}
		>=dev-libs/libxml2-2.6.28
		>=dev-util/pkgconfig-0.9"

src_compile() {
	eautoreconf
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README ChangeLog AUTHORS TODO
}
