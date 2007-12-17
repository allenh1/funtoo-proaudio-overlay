# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="oss alsa jack"

inherit eutils
RESTRICT=nomirror
MY_P=${P/_rc/-rc}
MY_P=${MY_P/amsynth/amSynth}

DESCRIPTION="A retro analogue - modelling softsynth"
HOMEPAGE="http://amsynthe.sourceforge.net/"
SRC_URI="mirror://sourceforge/amsynthe/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

# libsndfile support is actually optional, but IMHO this package should have it
DEPEND=">=dev-cpp/gtkmm-2.4
	>=media-libs/libsndfile-1.0
	alsa? ( >=media-libs/alsa-lib-0.9 media-sound/alsa-utils )
	jack? ( media-sound/jack-audio-connection-kit )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	econf `use_with oss` `use_with alsa` `use_with jack` || die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	einfo
	einfo "amSynth has been installed normally."
	einfo "If you would like to use the virtual"
	einfo "keyboard option, then do"
	einfo "emerge vkeybd"
	einfo "and make sure you emerged amSynth"
	einfo "with alsa support (USE=alsa)"
	einfo
}
