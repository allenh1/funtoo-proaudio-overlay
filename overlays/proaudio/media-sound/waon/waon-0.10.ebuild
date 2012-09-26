# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs

DESCRIPTION="A wave to notes transcriber, able to transcribe wav to midi"
HOMEPAGE="http://waon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk pv"

OCDEPEND="media-libs/libao
	media-libs/libsamplerate"
RDEPEND="media-libs/libsndfile
	sci-libs/fftw:3.0
	pv? ( ${OCDEPEND} )
	gtk? ( x11-libs/gtk+:2
		   ${OCDEPEND} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(ChangeLog README TIPS TODO)

src_prepare() {
	base_src_prepare
	sed -i -e "s/-O3//" Makefile || die
}

src_compile() {
	tc-export CC
	base_src_make waon
	use pv && base_src_make pv
	use gtk && base_src_make gwaon
}

src_install() {
	# no make install in makefile
	dobin waon
	doman waon.1

	if use pv; then
		dobin pv
		doman pv.1
	fi

	if use gtk; then
		dobin gwaon
		doman gwaon.1
	fi

	base_src_install_docs
}
