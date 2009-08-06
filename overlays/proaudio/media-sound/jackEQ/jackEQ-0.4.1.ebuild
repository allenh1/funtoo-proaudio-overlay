# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="jackEQ is a tool for routing and manipulating audio from/to
multiple input/output sources"
HOMEPAGE="http://jackeq.sourceforge.net"
SRC_URI="mirror://sourceforge/jackeq/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${RDEPEND}
		>=media-sound/jack-audio-connection-kit-0.100.0
		>=media-libs/ladspa-sdk-1.12
		media-plugins/swh-plugins
		dev-libs/libxml2"
RDEPEND="=x11-libs/gtk+-2*
		>=dev-util/pkgconfig-0.8"

src_install() {
	make DESTDIR="${D}" install || die "installation failed"
	dodoc README AUTHORS NEWS TODO
}


