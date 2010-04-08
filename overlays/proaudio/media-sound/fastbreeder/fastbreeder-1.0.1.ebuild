# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils python

DESCRIPTION="An experimental genetic programming synthesiser."
HOMEPAGE="http://www.pawfal.org/Software/fastbreeder/"
SRC_URI="http://www.pawfal.org/Software/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"
RESTRICT="mirror"

RDEPEND=">=media-libs/liblo-0.26
		>=dev-lang/python-2.6[tk]
		>=media-sound/jack-audio-connection-kit-0.116.2"
DEPEND="dev-util/scons
		${RDEPEND}"

src_prepare () {
	# compiler flags need attention
	local dbg
	if use debug; then dbg="-ggdb"; fi
	sed -i -e "s:-pipe -Wall -O3 -ggdb:${CXXFLAGS} ${dbg} -Wall:g" \
		"${S}/SConstruct" || die "sed of SConstruct failed"
}

src_compile() {
	scons || die "scons configure failed"
}

src_install() {
	# after trying to patch SConstruct to install to /usr it was figured
	# that although this is ugly, it gets the job done.
	insinto	"$(python_get_sitedir)"
	doins "${WORKDIR}/${P}/scripts/osc.py"
	doins "${WORKDIR}/${P}/scripts/gpy.py"
	dobin "${WORKDIR}/${P}/fastbreederserver"
	dobin "${WORKDIR}/${P}/scripts/fastbreeder"
	dodoc README
}
