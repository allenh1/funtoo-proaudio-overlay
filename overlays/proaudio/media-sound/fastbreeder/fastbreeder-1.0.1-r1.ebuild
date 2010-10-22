# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="tk"

inherit eutils python toolchain-funcs scons-utils

DESCRIPTION="An experimental genetic programming synthesiser."
HOMEPAGE="http://www.pawfal.org/Software/fastbreeder/"
SRC_URI="http://www.pawfal.org/Software/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=media-libs/liblo-0.26
		>=media-sound/jack-audio-connection-kit-0.116.2"
DEPEND="${RDEPEND}"

src_prepare () {
	# patch for respecting toolchain flags
	epatch "${FILESDIR}/${P}-SConstruct.patch"
}

src_compile() {
	tc-export CXX
	escons || die "escons failed"
}

src_install() {
	# this could be better, using scons to install is a pain in the *
	insinto	"$(python_get_sitedir)"
	doins scripts/osc.py scripts/gpy.py || die
	dobin fastbreederserver scripts/fastbreeder || die
	dodoc README
}
