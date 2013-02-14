# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="MIDI sequencer based on the Doepfer Schaltwerk analog sequencer"
HOMEPAGE="http://softwerk.sourceforge.net/"
SRC_URI="http://ardour.org/files/${P}.tar.bz2
	http://ardour.org/files/${PN}.patch
	http://download.tuxfamily.org/proaudio/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/libxml2
	virtual/libusb
	dev-libs/boost
	media-libs/liblo
	media-libs/alsa-lib
	>=dev-cpp/gtkmm-2.4
	dev-libs/libsigc++
	>=dev-cpp/glibmm-2.4
	sys-devel/gettext[nls]
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${DISTDIR}"/${PN}.patch

	# fix include with recent glib
	sed -i -e "s:<glib/gfileutils.h>:<glib.h>:" src/configuration.cc || die
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons \
		PREFIX=/usr ARCH="${CXXFLAGS}"
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons install \
		PREFIX=/usr \
		DESTDIR="${D}"

	doicon "${DISTDIR}/softwerk.png"
	make_desktop_entry "${PN}" SoftWerk "${PN}" "AudioVideo;Audio;Sequencer;"
}

pkg_postinst() {
	einfo "You can find the out-to-date SoftWerk documentation at"
	einfo "http://softwerk.sourceforge.net/manual/contents.html"
	einfo "See also http://lwm.net/Articles/520348/"
}
