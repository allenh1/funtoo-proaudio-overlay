# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features."
HOMEPAGE="http://www.linuxsampler.org/"
#SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="linuxsampler"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="jack"

S=${WORKDIR}/${ECVS_MODULE}


RDEPEND="
	>=media-libs/liblscp-9999
	>=media-libs/libgig-9999
	media-libs/alsa-lib
	!media-sound/linuxsampler-cvs
	jack? ( media-sound/jack-audio-connection-kit )"

DEPEND="${RDEPEND}"

src_unpack() {
	cvs_src_unpack
	cd ${S}
}
	
src_compile() {
	make -f Makefile.cvs
	econf || die "./configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README
}
