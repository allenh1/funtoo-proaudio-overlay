# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

At1="Minster1_000_WX_48k.wav"
At2="Minster1_000_YZ_48k.wav"

IUSE=""

inherit eutils multilib toolchain-funcs
RESTRICT="mirror"

DESCRIPTION="Aeolus with conbolution reverb using Ambiosonic impulse responses by Fons Adriaensen"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/aeolus"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2
	${At1}
	${At2}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="|| ( x11-libs/libX11 virtual/x11 )
	media-libs/aeolus-ym-files
	>=media-libs/libclxclient-3.3.2
	>=media-libs/libclalsadrv-1.2.2
	>=media-libs/libsndfile-1.0.17
	>=media-libs/stops-0.3.0
	>=media-libs/zita-convolver-0.1.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake || die "emake failed"
	./mkwavex -A "${DISTDIR}/${At1}" "${DISTDIR}/${At2}" \
	    Minster1_000_WXYZ_48k.amb || die "mkwavex failed"
}

src_install() {
	make DESTDIR="${D}" install || die "installation failed"
	insinto /etc
	doins ${FILESDIR}/aeolus.conf
	dodoc AUTHORS README ${FILESDIR}/README4gentoo
	insinto /usr/share/stops
	doins *.amb
}

pkg_postinst() {
	ewarn ""
	ewarn "Aeolus-ym will coesxist with Aeolus"
	ewarn "Just run aeolus-ym to start it"
	ewarn ""
	ewarn "Aeolus-ym is configured to use JACK by default. You can make it"
	ewarn "use ALSA by adding following line to ~/.aeolusrc"
	ewarn ""
	ewarn "-u -A -S /usr/share/stops"
	ewarn ""
	ewarn "By default the presets will get stored in ~/.aeolus-presets"
	ewarn "See the README.gz for more config options."
	ewarn ""
	ewarn "# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
	ewarn "This package was not intended for release by Fons Adriaensen!!!"
	ewarn "Please, don't ask him questions about support for aeolus-ym!!!"
	ewarn "# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #"
}
