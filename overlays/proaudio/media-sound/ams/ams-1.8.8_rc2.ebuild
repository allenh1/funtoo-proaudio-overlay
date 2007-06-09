# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib versionator exteutils

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
	 =sci-libs/fftw-2*
	 media-libs/ladspa-sdk
	 media-libs/libclalsadrv"

DEPEND="${RDEPEND}
	sys-apps/sed"

SRC_URI="mirror://sourceforge/alsamodular/${MY_P}.tar.bz2"
RESTRICT="nomirror"

S="${WORKDIR}/${MY_P}"
src_unpack(){
	unpack "${A}"
	cd "${S}"
	esed_check -i -e "s@-O3 -march=k8 -mtune=k8 -m64 -Wall@${CXXFLAGS}@g" \
			-e 's@\(QT_INCLUDE_DIR\=\)/usr/include/qt3@\1/usr/qt/3/include@g' \
			-e 's@^\(QT_LIB_DIR\=\).*@\1$(QT_BASE_DIR)/lib@g' \
			-e 's@^\(QT_BIN_DIR\=\).*@\1$(QT_BASE_DIR)/bin@g' \
			-e 's@^\(QT_INCLUDE_DIR\=\).*@\1$(QT_BASE_DIR)/include@g' \
			-e "s@^\(QT_BASE_DIR\=\).*@\1${QTDIR}@g" Makefile

	# change include header
	esed_check -i -e 's@#include <rfftw.h>@#include <srfftw.h>@g' spectrumscreen.h
	esed_check -i -e 's@#include <rfftw.h>@#include <srfftw.h>@g' spectrumscreen.cpp
	# using old code to get it compiled
	esed_check -i -e '/#ifdef OUTDATED_CODE/d' -e '$D' spectrumscreen.h
}

src_compile() {
	emake QT_BASE_DIR="${QTDIR}" QT_LIB_DIR="${QTDIR}/$(get_libdir)" || die "Make failed."
}

src_install() {
	dobin ams
	dodoc README THANKS
	docinto examples
	dodoc *.ams
}
