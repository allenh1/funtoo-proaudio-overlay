# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="A Midi Controllable Audio Sampler"
HOMEPAGE="http://zhevny.com/specimen"
MY_P="${P/_/-}"
SRC_URI="http://zhevny.com/${PN}/files/${MY_P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"

IUSE="lash debug" # jackmidi"

RDEPEND="media-sound/jack-audio-connection-kit
	>=media-libs/alsa-lib-0.9
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.4.0
	>=dev-libs/libxml2-2.0
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomecanvas-2.0
	lash? ( media-sound/lash )"

DEPEND="${RDEPEND}
	>=gnome-base/libgnomeui-2.0
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:-Werror::" -e "s:-O3:${CFLAGS}:" -i configure
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable lash) \
		|| die "config failed"
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog NEWS PROFILE \
		README ROADMAP TODO STYLE TODO WISHLIST
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} Specimen ${PN}
}
