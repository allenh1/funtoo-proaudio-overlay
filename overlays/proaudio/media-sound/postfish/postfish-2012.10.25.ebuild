# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Digital audio post-processing, restoration, filtering and mixdown tool"
HOMEPAGE="https://svn.xiph.org/trunk/postfish/"
# pristine svn snapshot
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sci-libs/fftw:3.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake ETCDIR="${EPREFIX}"/etc/postfish CC="$(tc-getCC)"
}

src_install() {
	# make install links binary again, using helpers instead
	dobin postfish
	#doman postfish.1
	insinto /etc/postfish
	doins postfish-gtkrc postfish-wisdomrc
	dodoc README
}
