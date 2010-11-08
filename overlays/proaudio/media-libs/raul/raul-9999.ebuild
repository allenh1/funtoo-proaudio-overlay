# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs multilib eutils subversion

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications."
HOMEPAGE="http://wiki.drobilla.net/Raul"
#SRC_URI="http://download.drobilla.net/${P}.tar.bz2"
SRC_URI=""
ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"

RDEPEND="dev-libs/boost
	>=dev-libs/glib-2.14.0"
DEPEND="${RDEPEND}
	>=dev-python/rdflib-3.0.0
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

RAUL_TESTS="atomic_test atom_test list_test midi_ringbuffer_test path_test quantize_test queue_test ringbuffer_test smf_test table_test thread_test time_test"
#atomic_test list_test midi_ringbuffer_test path_test ringbuffer_test smf_test thread_test"

src_configure() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"

	tc-export CC CXX CPP AR RANLIB
	./waf configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs") \
		$(use test && echo "--test") \
		|| die
}

src_compile() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"

	./waf || die
}

src_test() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"

	cd "${S}/build/default/test" || die
	for i in ${RAUL_TESTS} ; do
		einfo "Running test ${i}"
		LD_LIBRARY_PATH=.. ./${i} || die
	done
}

src_install() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"

	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache

	./waf install --destdir="${D}" || die
	dodoc AUTHORS README ChangeLog
}
