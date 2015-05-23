# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

RESTRICT=mirror
DESCRIPTION="A vocoder is a sound effect that can make a human voice sound
synthetic"
HOMEPAGE="http://www.sirlab.de/linux/descr_vocoder.html"
SRC_URI="http://www.sirlab.de/linux/download/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
MY_P="${P/-ladspa/}"
S=${WORKDIR}/${MY_P}

src_unpack(){
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/stereo-0001.patch.gz"
}
src_compile() {
	emake || die
}

src_install() {
	dodoc COPYRIGHT README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
