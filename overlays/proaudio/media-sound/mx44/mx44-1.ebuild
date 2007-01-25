# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator
RESTRICT="nomirror"
MY_PN="${PN/m/M}"
MY_P="${MY_PN}.$(replace_version_separator "0" "-")"

DESCRIPTION="Mx44 is a polyphonic midi realtime software synthesizer"
HOMEPAGE="http://hem.passagen.se/ja_linux/"
SRC_URI="http://hem.passagen.se/ja_linux/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND="media-sound/jack-audio-connection-kit
		>=x11-libs/gtk+-2.0
		media-libs/alsa-lib"

S="${WORKDIR}/${MY_P}"
src_unpack() {
	unpack "${A}"
	cd "${S}"
	echo 'FLAGS += $(CFLAGS)' >> Makefile
}

src_install() {
	mv mx44 mx44.bin
	dobin ${FILESDIR}/mx44 mx44.bin || die "install mx44 failed"
	dodoc COPYING ${FILESDIR}/README.Gentoo || die "install doc failed"
	insinto /usr/share/mx44
	doins mx41patch || die "instal mx41patch failed"
}
