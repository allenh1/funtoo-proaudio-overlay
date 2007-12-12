# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="AZR3"
HOMEPAGE=""

ECVS_SERVER="cvs.savannah.nongnu.org:/sources/ll-plugins"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit
	dev-cpp/gtkmm
	media-sound/lash"
RDEPEND="${DEPEND}"

src_compile() {
	# strange nonstandard homebrewn configure crap
	./configure \
		--prefix=/usr \
		--CFLAGS="${CFLAGS}" \
		--LDFLAGS="${LDFLAGS}" \
	|| die

	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README AUTHORS
}
