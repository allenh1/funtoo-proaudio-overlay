# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

RESTRICT="mirror"
IUSE="jack lash devel-patches"
DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="http://www.filter24.org/seq24/"
SRC_URI="http://www.filter24.org/seq24/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND=">=media-libs/alsa-lib-1.0.15
	>=dev-cpp/gtkmm-2.4
	>=dev-libs/libsigc++-2.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.90.0 )
	lash? ( virtual/liblash )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if use devel-patches; then
		epatch "${FILESDIR}/${P}.prio.diff"
		epatch "${FILESDIR}/${P}-menu-changes.diff"
		epatch "${FILESDIR}/${P}-label-fix.diff"
		epatch "${FILESDIR}/${P}.olivier.patch"
	fi

	if has_version ">=dev-libs/libsigc++-2.2"; then
		epatch "${FILESDIR}/${P}-sigc22_fix.patch"
	fi
}

src_configure() {
	export WANT_AUTOCONF=2.5

	if use devel-patches ;then
		autoconf || die "autoconf failed"
		autoreconf
	fi

	econf \
		$(use_enable jack jack-support) \
		$(use_enable lash) \
		--disable-alsatest \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README RTC SEQ24
	doicon "${FILESDIR}/${PN}.xpm"
	make_desktop_entry "${PN}" "SEQ24" "${PN}" "AudioVideo;Audio;Sequencer"
}
