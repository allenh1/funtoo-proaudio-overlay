# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="RSound is a networked audio system. It allows applications to
transfer their audio data to a different computer."
HOMEPAGE="http://www.rsound.org/"
SRC_URI="http://github.com/downloads/Themaister/RSound/${PN}-1.0beta1.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa ao openal portaudio pulseaudio" # muroar oss

S="${WORKDIR}/${PN}-1.0beta1"

RDEPEND="media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	openal? ( media-libs/openal )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"

pkg_setup() {
	DOCS+=" AUTHORS ChangeLog DOCUMENTATION README"
}

src_configure() {
	./configure \
		"${D}"/usr \
		--disable-roar \
		$(use_enable alsa) \
		$(use_enable ao libao) \
		$(use_enable openal) \
		$(use_enable portaudio) \
		$(use_enable pulseaudio pulse)
}

src_install() {
	emake install
	dodoc AUTHORS ChangeLog DOCUMENTATION README
}
