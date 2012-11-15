# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="Console/Qt4 programs that listen to MIDI machine control messages (MMC) to drive JACK transport"
HOMEPAGE="http://jackctlmmc.sourceforge.net/"
SRC_URI="mirror://sourceforge/jackctlmmc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="lash +jackmidi"

RDEPEND="media-libs/alsa-lib
	>=media-sound/jack-audio-connection-kit-0.109.2
	lash? ( media-sound/lash )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch" || die "patching failed"
	eautomake
}

src_configure() {
	tc-export CC
	econf \
	--enable-gui=no \
	$(use_enable lash) \
	$(use_enable jackmidi) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc NEWS README VERSION
}
