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
KEYWORDS="~amd64 ~ppc sparc x86"

IUSE="lash debug" # jackmidi"

RDEPEND="media-sound/jack-audio-connection-kit
	virtual/alsa
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.4.0
	>=dev-libs/libxml2-2.0
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomecanvas-2.0
	lash? ( media-sound/lash )"

DEPEND="${RDEPEND}
	>=gnome-base/libgnomeui-2.0"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch "${FILESDIR}/jack_client.patch"
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
