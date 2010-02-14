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

#SRC_URI=""


KEYWORDS=""
DEPEND="media-libs/libsamplerate
	dev-libs/openssl
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${PN}"
EGIT_BOOTSTRAP="./bootstrap.sh"

src_unpack() {
	git_src_unpack || die "unpack failed"
#	cd ${S} || die "cd failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
