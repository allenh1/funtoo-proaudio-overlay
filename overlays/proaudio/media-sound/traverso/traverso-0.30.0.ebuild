# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions qt4

RESTRICT="nomirror"
DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://vt.shuis.tudelft.nl/~remon/traverso"
SRC_URI="http://vt.shuis.tudelft.nl/~remon/traverso/${P}.tar.gz"

IUSE="static jack alsa"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc"

DEPEND="|| ( ( x11-libs/libXt )
	virtual/x11 )
	$(qt4_min_version 4)
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	media-libs/libsndfile
	media-libs/libsamplerate"

#set-qtdir 4

src_unpack() {
	unpack ${A}
	cd ${S}
	use jack || sed -ie "s:^\(DEFINES\ +=\ JACK_SUPPORT.*\):#\1:" src/base.pri
	use alsa || sed -ie "s:^\(DEFINES\ +=\ ALSA_SUPPORT.*\):#\1:" src/base.pri
	sed -ie "s:^\(DESTDIR_TARGET\ =\) \(.*\):\1 /usr/bin:" src/traverso/traverso.pro
	sed -ie "s:^\(\#define\ RESOURCES_DIR\) \(.*\):\1 \"/usr/share/traverso\":" src/config.h
	sed -ie "s:^\(target.path\ =\) \(.*\):\1 /usr/bin:" src/traverso/traverso.pro

}

src_compile() {
	QMAKE="/usr/bin/qmake"
	$QMAKE  traverso.pro || die "qmake failed"
	#econf $(use_enable static) || die "configure failed"
	emake || die
}

src_install() {
	emake INSTALL_ROOT=${D} install || die
	dodoc AUTHORS ChangeLog README
}
