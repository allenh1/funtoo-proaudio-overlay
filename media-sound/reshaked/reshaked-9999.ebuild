# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="ReShaked is a next generation tracker/sequencer"
HOMEPAGE="http://reshaked.berlios.de"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/reshaked/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug optimize"

RDEPEND=">=media-libs/libsdl-1.2.11
		media-libs/libpng"
DEPEND="${RDEPEND}
		dev-util/scons
		virtual/pkgconfig"

src_compile() {
	local myconf=""
	use debug || myconf="debug=0"
	use optimize && myconf="${myconf} optimize=1"
	scons ${myconf} || die "scons failed"
}

src_install() {
	#scons prefix="${D}/usr" install || die "scons install failed"
	dobin program/${PN}
}

