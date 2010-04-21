# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit git eutils

DESCRIPTION="The Non Sequencer is a powerful real-time, pattern-based MIDI sequencer for Linux."
HOMEPAGE="http://non-sequencer.tuxfamily.org/"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/sequencer.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lash"

DEPEND=">=x11-libs/fltk-1.1.2:1.1
	>=dev-libs/libsigc++-2.0
	>=media-sound/jack-audio-connection-kit-0.103
	lash? ( >=media-sound/lash-0.5.4 )"
RDEPEND="${DEPEND}"

src_unpack(){
	git_src_unpack || die "git clone failed."
	cd "${S}"
	# don't strip the binary
	sed -i -e '/strip/d' "${S}/Makefile" || die "sed of Makefile failed"
}

src_compile() {
	# configure is a hand written shell script, thus econf will not work
	./configure --prefix=/usr $(use_enable lash) || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	fowners root:audio  "${ROOT}"/usr/bin/non-sequencer || die "chown failed"
}
