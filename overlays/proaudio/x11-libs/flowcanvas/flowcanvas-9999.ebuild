# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

DESCRIPTION="Gtkmm/Gnomecanvasmm widget for boxes and lines environments"
HOMEPAGE="http://wiki.drobilla.net/FlowCanvas"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

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

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs")
}

src_compile() {
	cd ${PN}
	waf-utils_src_compile
}

src_install() {
	cd ${PN}
	waf-utils_src_install
	dodoc AUTHORS README ChangeLog

	if use doc; then
		mv "${D}/usr/share/doc/${PN}/html" "${D}/usr/share/doc/${PF}"
		rmdir "${D}/usr/share/doc/${PN}"
		find "${D}/usr/share/doc/" -name '*.md5' -delete
	fi
}
