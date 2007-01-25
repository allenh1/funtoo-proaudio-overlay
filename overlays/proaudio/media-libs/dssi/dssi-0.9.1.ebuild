# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/dssi/dssi-0.9.ebuild,v 1.2 2006/01/04 17:38:07 wormo Exp $

inherit eutils multilib

IUSE="qt"
RESTRICT="nomirror"
DESCRIPTION="DSSI Soft Synth Interface"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND=">=media-libs/alsa-lib-1.0
	>=media-libs/liblo-0.12
	>=media-sound/jack-audio-connection-kit-0.99.0-r1
	>=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/libsndfile-1.0.11
	>=media-libs/libsamplerate-0.1.1-r1
	sys-apps/sed
	dev-util/pkgconfig
	qt? ( >=x11-libs/qt-3 )"

src_unpack() {
	unpack ${A}
#	cd ${S}
}

src_compile() {
econf || die
emake || die
}

src_install() {
	einstall || die
	dodoc README doc/TODO doc/*.txt ChangeLog
}
