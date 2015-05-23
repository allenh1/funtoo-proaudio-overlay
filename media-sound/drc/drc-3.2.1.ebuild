# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs flag-o-matic

DESCRIPTION="Generate digital room correction FIR filters for use in realtime
convolution engines like BruteFIR"
HOMEPAGE="http://drc-fir.sourceforge.net"
SRC_URI="mirror://sourceforge/drc-fir/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="double-precision"

RESTRICT="mirror"

DEPEND=">=sci-libs/gsl-1.14"
RDEPEND="${DEPEND}"

DOCS=( "${S}/readme.txt" )
HTML_DOCS=( "${S}/doc/" )

S=${WORKDIR}/${P}/source

PATCHES=("${FILESDIR}"/${P}-makefile.patch)

src_compile() {
	use double-precision && append-cppflags -DUseDouble
	CC="$(tc-getCC)" base_src_make
}

src_install() {
	# make install in makefile needs looking at
	dobin drc glsweep lsconv
	insinto /usr/share/drc
	doins -r config/ target/ mic/
	insinto /usr/share/drc/impulse
	doins ../sample/rs.pcm
	base_src_install_docs
}

pkg_postinst() {
	einfo "Example sample, config and contrib files are in /usr/share/${PN}/*"
	einfo "Documentation is in /usr/share/doc/${PF}/readme.txt* or"
	einfo "/usr/share/doc/${PF}/html/drc.html"
	einfo "To use this package emerge media-sound/brutefir"
}
