# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

IUSE="qt3"
RESTRICT="nomirror"
DESCRIPTION="Plugin API for software instruments with user interfaces"
HOMEPAGE="http://dssi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND=">=media-libs/alsa-lib-1.0
	>=media-libs/liblo-0.12
	>=media-sound/jack-audio-connection-kit-0.99.0-r1
	>=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/libsndfile-1.0.11
	>=media-libs/libsamplerate-0.1.1-r1
	qt3? ( >=x11-libs/qt-3 )"
DEPEND="${RDEPEND}
	sys-apps/sed
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	sed -i -e "s:/lib:/$(get_libdir):" ${S}/dssi.pc.in || die
#	cd ${S}
}

src_compile() {
	use qt3 || QTDIR=/WONT_BE_FOUND
	econf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc README doc/TODO doc/*.txt ChangeLog
}
