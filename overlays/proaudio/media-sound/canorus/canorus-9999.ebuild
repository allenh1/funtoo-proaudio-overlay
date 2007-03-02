# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib qt4 subversion

ESVN_REPO_URI="svn://svn.berlios.de/canorus/trunk"
ESVN_PROJECT="canorus"

DESCRIPTION="Graphical Score-editor using Qt4"
HOMEPAGE="http://canorus.berlios.de"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="python ruby"

DEPEND="$(qt4_min_version 4.2.0)
        >=dev-util/cmake-2.4.2
		dev-lang/swig
        python? ( dev-lang/python )
        ruby?   ( dev-lang/ruby )"

pkg_setup() {
	ewarn "if this ebuild fails have a look at"
	ewarn "http://bugs.gentoo.org/show_bug.cgi?id=157501"
	ewarn "hav no time to fix the ebuild"
}

src_compile() {
	cmake \
		-DCMAKE_INSTALL_PREFIX:PATH=/usr \
		-DCANORUS_INSTALL_LIB_DIR=$(get_libdir) \
		-DNO_PYTHON=$( use python && echo false || echo true ) \
		-DNO_RUBY=$( use ruby && echo false || echo true ) \
	. || die

	emake || die
}

src_install() {
		emake install DESTDIR=${D} || die
}
