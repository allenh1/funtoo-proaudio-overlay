# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils multilib toolchain-funcs
RESTRICT="nomirror"
MY_P="${P}-2"

DESCRIPTION="A synthesised pipe organ emulator by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/aeolus.html"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
	
DEPEND="|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/libclxclient-3.3.0
	>=media-libs/libclalsadrv-1.1.0
	>=media-libs/stops-0.3.0" 

src_unpack() {
	unpack ${A}
	cd ${S}
	#sed  -i -e 's:-I/usr/local/include:-I/usr/include:g'  ${S}/Makefile || die
	epatch "${FILESDIR}/${P}-r1-makefile.patch"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "installation failed"
	insinto /etc
	doins ${FILESDIR}/aeolus.conf
	dodoc AUTHORS README
}

pkg_postinst() {
	ewarn ""
	ewarn "Aeolus is configured to use JACK by default. You can make it"
	ewarn "use ALSA by adding following line to ~/.aeolusrc"
	ewarn ""
	ewarn "-u -A -S /usr/share/stops"
	ewarn ""
	ewarn "By default the presets will get stored in ~/.aeolus-presets"
	ewarn "See the README.gz for more config options."
	ewarn ""
}
