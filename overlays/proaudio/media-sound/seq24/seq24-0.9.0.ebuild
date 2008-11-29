# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

RESTRICT="nomirror"
IUSE="jack lash"
DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="http://www.filter24.org/seq24/"
SRC_URI="http://code.edge.launchpad.net/seq24/trunk/0.9.0/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/alsa-lib-1.0.15[midi]
	>=dev-cpp/gtkmm-2.4
	>=dev-libs/libsigc++-2.0
	jack? ( >=media-sound/jack-audio-connection-kit-0.90.0 )
	lash? ( >=media-sound/lash-0.5.0 )"
	#cairo? ( x11-libs/cairo )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		$(use_enable jack jack-support) \
		$(use_enable lash) \
		--disable-alsatest \
		|| die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README RTC SEQ24
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry "${PN}" "SEQ24" "${PN}" "AudioVideo;Audio;Sequencer"
}
