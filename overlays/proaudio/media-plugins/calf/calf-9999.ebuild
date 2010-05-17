# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit git

DESCRIPTION="Calf is a set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf.sf.net/"

EGIT_REPO_URI="git://repo.or.cz/calf.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
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

src_compile() {
	NOCONFIGURE=1 ./autogen.sh
	econf \
	$(use_enable debug) \
	$(use_with ladspa) \
	$(use_with lv2) \
	|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
}
