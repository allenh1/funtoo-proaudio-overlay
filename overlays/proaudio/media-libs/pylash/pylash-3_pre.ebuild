# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

IUSE=""

DESCRIPTION="Python bindings for LASH."
HOMEPAGE="http://nedko.arnaudov.name/soft/pylash/"
MY_P="${P/3_pre/pre-3}"
SRC_URI="http://nedko.arnaudov.name/soft/pylash/${MY_P}.tar.bz2"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${MY_P}"

# Not sure about the required swig version, report if 1.3.25 doesn't work
DEPEND="dev-lang/python
	>=dev-lang/swig-1.3.25
	>=media-sound/lash-0.5.0"

pkg_setup() {
	if ! built_with_use swig python ; then
		eerror "Please re-emerge swig with USE='python'"
		die
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use amd64 && epatch "${FILESDIR}/${P}-fPIC.patch"
}
src_compile() {
	emake || die
}

src_install() {
	python_version
	insinto /usr/lib/python${PYVER}/site-packages
	doins lash.py
	insopts -m0755
	doins _lash.so
}

pkg_postinst() {
	python_mod_optimize /usr/lib/python${PYVER}/site-packages/
}

pkg_postrm() {
	distutils_pkg_postrm
}
