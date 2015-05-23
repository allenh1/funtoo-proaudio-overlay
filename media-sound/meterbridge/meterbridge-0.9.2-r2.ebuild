# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools exteutils

IUSE="lash"

DESCRIPTION="Software meterbridge for the UNIX based JACK audio system."
HOMEPAGE="http://plugin.org.uk/meterbridge/"
SRC_URI="http://plugin.org.uk/meterbridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="media-sound/jack-audio-connection-kit
	media-libs/sdl-image
	lash? ( >=media-sound/lash-0.5.0 )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/meterbridge_0.9.2-4.0.0.1.gcc4.patch"
	use lash && epatch "${FILESDIR}/meterbridge-lash.patch"
	local olddir="$PWD"
	cd src/
	# asneeded and cflags fix
	esed_check -i -e "s@^\(meterbridge_LD\)FLAGS\(.*\)@\1ADD\2@g" \
		-e "s@^\(CFLAGS\)@AM_\1@g" Makefile.am
	cd "$olddir"

	export WANT_AUTOCONF=2.5
	#export WANT_AUTOMAKE=1.6
	eautoreconf
}

src_compile() {
	econf $(use_enable lash) || die "econf failed"
		emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	doman "${FILESDIR}/meterbridge.1.gz"
	dodoc AUTHORS ChangeLog
}
