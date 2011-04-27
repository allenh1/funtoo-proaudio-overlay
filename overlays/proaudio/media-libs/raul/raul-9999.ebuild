# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications."
HOMEPAGE="http://wiki.drobilla.net/Raul"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"

RDEPEND="dev-libs/boost
	>=dev-libs/glib-2.26.1-r1:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-lang/python
	doc? ( app-doc/doxygen )"

RAUL_TESTS="atom_test atomic_test list_test midi_ringbuffer_test path_test quantize_test queue_test ringbuffer_test smf_test table_test thread_test time_test"

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use doc && echo " --build-docs --htmldir=/usr/share/doc/${P}/html") \
		$(use test && echo "--test")
}

src_compile() {
	cd ${PN}
	waf-utils_src_compile
}

src_test() {
	cd "${PN}/build/test"

	for i in ${RAUL_TESTS} ; do
		einfo "Running test ${i}"
		LD_LIBRARY_PATH=.. ./${i} || die
	done
}

src_install() {
	cd ${PN}
	waf-utils_src_install
	dodoc AUTHORS README ChangeLog
}
