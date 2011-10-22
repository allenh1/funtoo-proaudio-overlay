# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git autotools

DESCRIPTION="libflashsupport.so for Adobe Flash with jack support"
HOMEPAGE="http://repo.or.cz/w/libflashsupport-jack.git"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"
EGIT_REPO_URI="git://repo.or.cz/libflashsupport-jack.git"
EGIT_MASTER="master"

IUSE=""

KEYWORDS=""
DEPEND="media-libs/libsamplerate
	dev-libs/openssl
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${PN}"
EGIT_BOOTSTRAP="./bootstrap.sh"

src_unpack() {
	einfo "${PN} is no longer maintained."
	einfo "Please use the JACK loopback instead:"
	einfo "http://alsa.opensrc.org/Jack_and_Loopback_device_as_Alsa-to-Jack_bridge"
	einfo ""
	einfo "Press Ctrl-C to abort ${PN} installation"
	epause 10

	git_src_unpack || die "unpack failed"

	# v4l1 is outdated and no longer into the linux kernel
	cd ${S}
	epatch "${FILESDIR}/remove-v4l1.patch" || die "epatch failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
