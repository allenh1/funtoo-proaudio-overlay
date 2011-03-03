# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

RESTRICT="mirror"
IUSE=""
DESCRIPTION="preamp LADSPA plugins"
HOMEPAGE="http://quitte.de/dsp/preamp.html"
SRC_URI="http://quitte.de/dsp/${PN}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="media-libs/ladspa-sdk"
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-Makefile.patch" || die "Patching failed!"
}

src_install() {
	dodir /usr/$(get_libdir)/ladspa
	make DESTDIR="${D}" DEST="/usr/$(get_libdir)/ladspa" install || die
	dodoc README
}
