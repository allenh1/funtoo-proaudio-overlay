# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git eutils

DESCRIPTION="The Non DAW is a powerful, reliable and fast modular Digital Audio Workstation system"
HOMEPAGE="http://non-sequencer.tuxfamily.org/"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/daw.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lash"

DEPEND=">=x11-libs/fltk-1.1.8
	>=media-libs/libsndfile-0.18.0
	>=media-sound/jack-audio-connection-kit-0.103
	lash? ( >=media-sound/lash-0.5.4 )"
RDEPEND="${DEPEND}"

src_unpack(){
	git_src_unpack || die "git clone failed."
	cd "${S}"
	# DESTDIR before prefix to stop sandbox violation
	sed -i -e 's:$(prefix):$(DESTDIR)$(prefix):g' \
		"${S}/Makefile" || die "sed of Makefile failed"
	# don't strip the binary
	sed -i -e '/strip/d' "${S}/Makefile" || die "sed of Makefile failed"
}

src_compile() {
	econf $(use_enable lash) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# make the bin directory or make will die because it's not found
	mkdir -p "${D}/usr/bin"
	emake DESTDIR="${D}" install || die "install failed"
	fowners root:audio  "${ROOT}/usr/bin/non-daw" || die "chown failed"
}
