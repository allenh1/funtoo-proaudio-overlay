# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

DESCRIPTION="liblscp is a C++ library for the Linux Sampler control protocol."
HOMEPAGE="http://www.linuxsampler.org/"
#SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="liblscp"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-*"
IUSE=""

S=${WORKDIR}/${ECVS_MODULE}

RDEPEND=""
DEPEND=""

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
} 
