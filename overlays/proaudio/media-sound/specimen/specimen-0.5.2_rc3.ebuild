# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils 
DESCRIPTION="A Midi Controllable Audio Sampler"
HOMEPAGE="http://zhevny.com/specimen"
MY_P="${P/_/-}"
SRC_URI="http://zhevny.com/specimen/files/${MY_P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc ~x86"

IUSE="lash debug" # jackmidi"

DEPEND="media-sound/jack-audio-connection-kit
	virtual/alsa
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.4.0
	>=dev-libs/libxml2-2.0
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomecanvas-2.0
	lash? ( media-sound/lash )"

S="${WORKDIR}/${MY_P}"
src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
#	epatch "${FILESDIR}/jack_client.patch"
}

src_compile() {

	#elibtoolize
	#./bootstrap
	econf \
		$(use_enable debug) \
		$(use_enable lash) \
		|| die "config failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
