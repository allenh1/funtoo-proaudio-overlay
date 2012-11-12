# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.7"
inherit eutils multilib python

RESTRICT="mirror"
DESCRIPTION="Open source music editor with a novel interface and fever limitations than trackers"
HOMEPAGE="http://users.notam02.no/~kjetism/${PN}/"
SRC_URI="http://dl.dropbox.com/u/4814054/${P}.tar.gz"

KEYWORDS="~x86 amd64"
SLOT="0"
IUSE="faust"

DEPEND="x11-libs/qt-core[qt3support]
	x11-libs/libXaw
	faust? ( dev-lang/faust )
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	media-libs/libsamplerate
	media-libs/liblrdf
	media-libs/libsndfile
	media-libs/ladspa-sdk
	>=dev-libs/glib-2.0
	media-plugins/calf
	>=media-libs/rtmidi-2.0.0[alsa,jack]"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}.patch" || die "epatch failed"
}

src_compile() {
	emake DESTDIR="${D}" PREFIX="/usr" libdir="/usr/$(get_libdir)" BUILDTYPE="RELEASE" \
		OPTIMIZE="${CXXFLAGS}" packages || die "make packages failed"
	./build_linux.sh -j7 || die "Build failed"
}

src_install() {
	emake libdir="/usr/$(get_libdir)" DESTDIR="${D}" PREFIX="/usr" install \
		|| die "install failed"
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/radium.xpm
	make_desktop_entry radium Radium "radium" "AudioVideo;Audio;AudioVideoEditing;"
}

#pkg_preinst() {
#	sed -i -e "s:${D}::" "${D}/usr/bin/radium" || "sed failed"
#}
