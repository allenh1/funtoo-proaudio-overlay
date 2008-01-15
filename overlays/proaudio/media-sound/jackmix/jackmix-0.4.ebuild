# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils qt4

RESTRICT="nomirror"
IUSE=""

DESCRIPTION="A mixer app for jack"
HOMEPAGE="http://www.arnoldarts.de/drupal/?q=JackMix%3Aintro"
SRC_URI="http://www.arnoldarts.de/drupal/files/downloads/jackmix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND}
		dev-util/scons
		dev-util/pkgconfig"
RDEPEND="media-sound/jack-audio-connection-kit
		$(qt4_min_version 4.2)
		>=media-libs/liblo-0.23"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	esed_check -i -e "s@\(^env\['CXXFLAGS'\].*\)\"@\1 ${CXXFLAGS}\"@" SConstruct
}
src_compile() {

	tc-export CC CXX
	QTDIR=/usr \
	scons CXXFLAGS="${CXXFLAGS}" qtlibs=/usr/lib/qt4 prefix="${D}"/usr || die "make failed"
}

src_install() {
#	scons install || die
	dobin jackmix/jackmix
	dodoc AUTHORS ChangeLog
	make_desktop_entry "${PN}" "JackMix" Audio "AudioVideo;Audio;Mixer"
}
