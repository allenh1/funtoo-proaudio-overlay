# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/specimen/specimen-0.5.1.ebuild,v 1.1.1.1 2006/04/10 11:50:09 gimpel Exp $

inherit eutils 
DESCRIPTION="A Midi Controllable Audio Sampler"
HOMEPAGE="http://zhevny.com/specimen"
SRC_URI="http://zhevny.com/specimen/files/${P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc sparc x86"

IUSE="lash debug" # jackmidi"

DEPEND="media-sound/jack-audio-connection-kit
	virtual/alsa
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.3.1
	>=dev-libs/libxml2-2.0
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomecanvas-2.0
	lash? ( media-sound/lash )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch "${FILESDIR}/jack_client.patch"
	use lash &&  epatch "${FILESDIR}/specimen-lash.patch"
	#use jackmidi && epatch "${FILESDIR}/specimen-jackmidi.diff"
	# workaround buggy configure
	sed -i -e 's|^PIXDIR\=.*|PIXDIR=\"/usr/share/specimen/pixmaps/\"|g' configure
}

src_compile() {

	#elibtoolize
	./bootstrap
	econf \
		$(use_enable debug) || die "config failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
