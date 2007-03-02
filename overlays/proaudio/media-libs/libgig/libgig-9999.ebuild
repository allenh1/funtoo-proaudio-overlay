# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

DESCRIPTION="libgig is a C++ library for loading Gigasampler files and DLS (Downloadable Sounds) Level 1/2 files."
HOMEPAGE="http://stud.fh-heilbronn.de/~cschoene/projects/libgig/"
# SRC_URI="http://stud.fh-heilbronn.de/~cschoene/projects/libgig/${P}.tar.bz2"

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="libgig"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"
RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"

S=${WORKDIR}/${ECVS_MODULE}

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	cvs_src_unpack
	cd ${S}
}

src_compile() {
	make -f Makefile.cvs
	econf || die "./configure failed"
	emake -j1 || die "make failed"

	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog TODO README

	if use doc; then
		mv ${S}/doc/html ${D}/usr/share/doc/${PF}/
	fi
}

