# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit base

DESCRIPTION="Calf is a set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug dssi +jack +lash +lv2 -ladspa"

DEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.12
	dssi? ( media-libs/dssi )
	lash? ( media-sound/lash )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( media-libs/lv2core )
	ladspa? ( media-libs/ladspa-sdk )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/c-files-include.patch"
}

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_with ladspa) \
		$(use_with lv2) \
		|| die
	emake || die
}
