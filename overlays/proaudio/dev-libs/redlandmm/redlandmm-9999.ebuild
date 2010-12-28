# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit multilib subversion toolchain-funcs

RESTRICT="mirror"
DESCRIPTION="An STL-style C++ wrapper for the Redland RDF Toolkit (librdf)"
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="doc debug"

RDEPEND="dev-libs/redland
	dev-libs/boost
	>=dev-cpp/glibmm-2.4"
DEPEND=">=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

src_prepare() {
	# redlandmm no longer provides a lib. works around link failure with ingen
	sed -i -e "s/-lredlandmm //" ${PN}/redlandmm.pc.in || die

	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd ${PN}

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)"
	use doc && myconf="${myconf} --build-docs
		--htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	tc-export CC CXX CPP AR RANLIB
	./waf configure ${myconf} || die
}

src_compile() {
	cd ${PN}
	./waf build || die
}

src_install() {
	cd ${PN}
	./waf install --destdir="${D}" || die
	dodoc AUTHORS README
}
