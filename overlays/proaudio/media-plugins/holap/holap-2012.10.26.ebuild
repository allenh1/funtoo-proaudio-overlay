# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"
inherit autotools flag-o-matic multilib

DESCRIPTION="Holborn Audio Plugins: DSSI and LADSPA audio plugins, including DSP effects and a FM synthesizer"
HOMEPAGE="http://holap.berlios.de/index.html"
# svn snapshot
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/liblo
	x11-libs/fltk:1"
DEPEND="${RDEPEND}
	media-libs/dssi
	media-libs/ladspa-sdk
	virtual/pkgconfig"

RESTRICT="mirror"

HOLAP_DSSI_PLUGINS="exciter goomf harmonizer horgand-dssi"
HOLAP_LADSPA_PLUGINS="harmonizer_l musicaldelay	zynalienwah zynchorus
	zyneq10band zyneq3par zynphaser zynreverb"
HOLAP_ALL_PLUGINS="${HOLAP_DSSI_PLUGINS} ${HOLAP_LADSPA_PLUGINS}"

src_prepare() {
	epatch "${FILESDIR}"/${P}/*.patch

	local p=
	for p in ${HOLAP_ALL_PLUGINS}; do
		cd "${S}"/"${p}"
		einfo "preparing ${p}"
		eaclocal
		_elibtoolize
		eautoheader
		eautoconf
		eautomake -a --gnu
	done
}

src_configure() {
	append-cppflags -I/usr/include/fltk-1
	append-ldflags -L/usr/$(get_libdir)/fltk-1

	local p=
	for p in ${HOLAP_ALL_PLUGINS}; do
		cd "${S}"/"${p}"
		einfo "configuring ${p}"
		econf --disable-dependency-tracking --disable-static
	done
}

src_compile() {
	local p=
	for p in ${HOLAP_ALL_PLUGINS}; do
		cd "${S}"/"${p}"
		einfo "compiling ${p}"
		emake
	done
}

src_install() {
	local p=
	for p in ${HOLAP_ALL_PLUGINS}; do
		cd "${S}"/"${p}"
		einfo "installing ${p}"
		emake DESTDIR="${ED}" install
		docinto "${p}"
		dodoc AUTHORS ChangeLog README
	done

	find "${ED}"/usr/"$(get_libdir)" -name '*.la' -exec rm -f {} \; || die
}
