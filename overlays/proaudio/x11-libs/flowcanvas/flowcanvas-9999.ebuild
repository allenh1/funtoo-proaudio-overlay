# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Gtkmm/Gnomecanvasmm widget for boxes and lines environments"
HOMEPAGE="http://wiki.drobilla.net/FlowCanvas"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

RDEPEND="dev-libs/boost
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/libgnomecanvasmm-2.6
	media-gfx/graphviz"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_compile() {
	cd ${PN}

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die
	./waf build ${MAKEOPTS} || die
}

src_install() {
	cd ${PN}
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README ChangeLog
}
