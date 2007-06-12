# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Alsa Modular Software Synthesizer"
HOMEPAGE="http://alsamodular.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-0.9
	 media-sound/jack-audio-connection-kit
	 =x11-libs/qt-3*
	 media-libs/ladspa-sdk
	 media-libs/libclalsadrv"

DEPEND="${RDEPEND}"

SRC_URI="mirror://sourceforge/alsamodular/${MY_P}.tar.bz2"
RESTRICT="nomirror"

S="${WORKDIR}/${MY_P}"
src_unpack(){
	unpack "${A}"
	cd "${S}"
	echo QMAKE_CFLAGS_RELEASE=${CFLAGS} >> ams.pro
	echo QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS} >> ams.pro
}

src_compile() {
	${QTDIR}/bin/qmake QMAKE="${QTDIR}/bin/qmake" || die "qmake failed"
	emake || die "Make failed."
}

src_install() {
	dobin ams
	dodoc README THANKS
	insinto /usr/share/${PN}
	doins -r demos/ tutorial/ instruments/
}
