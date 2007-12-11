# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
RESTRICT="nomirror"
IUSE="jack lash devel-patches" # cairo"
DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="http://www.filter24.org/seq24/"
SRC_URI="http://www.filter24.org/seq24/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND=">=media-libs/alsa-lib-0.9.0
	>=dev-cpp/gtkmm-2.4
	jack? ( >=media-sound/jack-audio-connection-kit-0.90.0 )
	lash? ( >=media-sound/lash-0.5.0 )"
	#cairo? ( x11-libs/cairo )"

src_unpack() {
	unpack ${A}
	cd ${S}
	#use cairo && use lash && epatch "${FILESDIR}/seq24-0.8.3-dr-lash-cairo.bz2"

	if use devel-patches; then
		epatch "${FILESDIR}/${P}.prio.diff"
		epatch "${FILESDIR}/${P}-menu-changes.diff"
		epatch "${FILESDIR}/${P}-label-fix.diff"
		epatch "${FILESDIR}/${P}.olivier.patch"
		#epatch "${FILESDIR}/${P}.olivier2.patch"
	fi
}

src_compile() {
	export WANT_AUTOCONF=2.5
	#export WANT_AUTOMAKE=1.6

	autoconf || die "autoconf failed"
	autoreconf

	econf $(use_enable jack jack-support) \
		 $(use_enable lash) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README RTC SEQ24
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry "${PN}" "SEQ24" "${PN}" "AudioVideo;Audio;Sequencer"
}
