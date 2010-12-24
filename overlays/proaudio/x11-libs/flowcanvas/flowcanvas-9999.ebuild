# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs multilib eutils subversion

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

src_configure() {
	cd "${S}/${PN}"
	tc-export CC CXX CPP AR RANLIB
	./waf configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs") \
		|| die
}

src_compile() {
	cd "${S}/${PN}"
	./waf || die
}

src_install() {
	cd "${S}/${PN}"
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README ChangeLog
}
