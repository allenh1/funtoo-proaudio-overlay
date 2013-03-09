# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.7"
inherit eutils multilib python

RESTRICT="mirror"
DESCRIPTION="Open source music editor with a novel interface and fever limitations than trackers"
HOMEPAGE="http://users.notam02.no/~kjetism/${PN}/"
SRC_URI="http://archive.notam02.no/arkiv/src/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+calf debug"
LICENSE="GPL-2"

DEPEND="dev-qt/qtcore[qt3support]
	x11-libs/libXaw
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	media-libs/libsamplerate
	media-libs/liblrdf
	media-libs/libsndfile
	media-libs/ladspa-sdk
	>=dev-libs/glib-2.0"
# repoman doesn't like this:
# RDEPEND="${DEPEND}
#	calf? ( <media-plugins/calf-0.0.19[ladspa] )"
# somebody knows?
if use calf; then
	RDEPEND="${DEPEND}
#	<media-plugins/calf-0.0.19[ladspa]"
else
	RDEPEND="${DEPEND}"
fi

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

#src_prepare() {
#	sed -i -e 's:DUSE_VESTIGE=0:DUSE_VESTIGE=1:' "${S}/Makefile.Qt" || die "sed failed"
#}

src_compile() {
	if use debug; then
		BUILDT=DEBUG
	else
		BUILDT=RELEASE
	fi
	emake DESTDIR="${D}" PREFIX="/usr" libdir="/usr/$(get_libdir)" \
		OPTIMIZE="${CXXFLAGS}" packages || die "make packages failed"
	BUILDTYPE="${BUILDT}" ./build_linux.sh -j7 || die "Build failed"
}

src_install() {
	emake libdir="/usr/$(get_libdir)" DESTDIR="${D}" PREFIX="/usr" install \
		|| die "install failed"
	insinto /usr/share/pixmaps
	doins "${FILESDIR}/radium.xpm"
	make_desktop_entry radium Radium "radium" "AudioVideo;Audio;AudioVideoEditing;"
}
