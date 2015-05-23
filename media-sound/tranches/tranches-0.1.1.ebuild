# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils scons-utils

DESCRIPTION="Tranches is midi-controlled multi-(inputs/outputs) live beat repeat/rearrange/redirect tool."
HOMEPAGE="http://tardigrade-inc.com/index.php/En/Tranches"
SRC_URI="http://www.tardigrade-inc.com/uploads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fr lash gui"

DEPEND="dev-libs/libxml2
		media-sound/jack-audio-connection-kit
		media-libs/libsamplerate
		media-libs/libsndfile"

RDEPEND="lash? ( media-sound/lash )
		   gui? ( =x11-libs/fltk-1.1.10* )"

src_prepare(){
	epatch "${FILESDIR}"/${P}-install.patch
	sed -i "s,CPPFLAGS=',CPPFLAGS=' -I/usr/include/fltk-1.1,"  SConstruct

	cd src/base
	sed -i "/#define tranches_h/ a\ \n#include <limits>" tranches.h
}

src_compile() {
	escons $(use_scons gui) $(use_scons lash) $(use_scons fr) || die "Compilation failed"
}

src_install(){
	escons bin_dir="${D}/usr/bin" desktop_dir="${D}/usr/share/applications" icon_dir="${D}/usr/share/pixmaps" install || die "Install failed"
}