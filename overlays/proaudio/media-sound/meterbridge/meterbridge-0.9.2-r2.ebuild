# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="lash"
inherit eutils
DESCRIPTION="Software meterbridge for the UNIX based JACK audio system."
HOMEPAGE="http://plugin.org.uk/meterbridge/"
SRC_URI="http://plugin.org.uk/meterbridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="media-sound/jack-audio-connection-kit
	media-libs/sdl-image
	lash? ( >=media-sound/lash-0.5.0 )"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/meterbridge_0.9.2-4.0.0.1.gcc4.patch"
	use lash && epatch "${FILESDIR}/meterbridge-lash.patch"
}

src_compile() {
	export WANT_AUTOCONF=2.5
	#export WANT_AUTOMAKE=1.6
		
	autoconf || die "autoconf failed"
	autoreconf

	econf $(use_enable lash) || die "econf failed"
		emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	doman "${FILESDIR}/meterbridge.1.gz"
	dodoc AUTHORS ChangeLog
}
