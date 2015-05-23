# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION="A softsynth to generate organ-like, organic-like, alien-like and
water-like sounds, plus various kinds of noise"
HOMEPAGE="http://www.notam02.no/~kjetism/sandysth/"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND=">=media-sound/snd-ls-0.9.7.4
	media-plugins/rev-plugins"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -ie 's/SND-LS-BIN=\/usr\/local/SND-LS-BIN=\/usr/' Makefile
	sed -ie 's/INSTALLDIR=\/usr\/local/INSTALLDIR=\/usr/' Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	insinto /usr/share/san-dysth/presets
	doins presets/*
	dodoc README
	dobin san-dysth
}
