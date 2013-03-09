# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="QT based GUI program that listens to MIDI machine control messages (MMC) to drive JACK transport"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://jackctlmmc.sourceforge.net/"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="mirror://sourceforge/jackctlmmc/jackctlmmc-4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="lash +jackmidi"

RDEPEND="media-libs/alsa-lib
	dev-qt/qtcore:4
	>=dev-qt/qtgui-4.4
	>=media-sound/jack-audio-connection-kit-0.109.2
	lash? ( media-sound/lash )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/jackctlmmc"

src_configure() {
	econf \
	$(use_enable lash) \
	$(use_enable jackmidi) \
	--enable-cli='no' || die "econf configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README VERSION
}
