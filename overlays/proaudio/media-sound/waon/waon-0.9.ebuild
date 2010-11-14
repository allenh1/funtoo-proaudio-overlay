# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="A wave to notes transcriber, able to transcribe wav to midi"
HOMEPAGE="http://waon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk +pv"

DEPEND="sci-libs/fftw:3.0
	media-libs/libsndfile
	pv? ( media-libs/libao
		  media-libs/libsamplerate )
	gtk? ( x11-libs/gtk+:2
		   media-libs/libao
		   media-libs/libsamplerate )"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	emake waon || die "emake waon failed"

	if use pv ; then
		emake pv || die "emake pv failed"
	fi

	if use gtk ; then
		emake gwaon || die "emake gwaon failed"
	fi
}

src_install() {
	# no make install
	dobin waon || die "dobin waon failed"
	doman waon.1

	if use pv ; then
		dobin pv || die "dobin pv failed"
		doman pv.1
	fi

	if use gtk ; then
		dobin gwaon || die "dobin gwaon failed"
		doman gwaon.1
	fi

	dodoc ChangeLog README TIPS TODO
}
