# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="A lua-based build environment generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc"

DEPEND="app-arch/unzip
	doc? ( app-doc/doxygen )"
RDEPEND=""

# Added in 4.1.2 for two test failures, prev versions were clean
RESTRICT=test
S="${WORKDIR}/${P}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	use debug && myconfig="debug" || myconfig="release"
	export CC=$(tc-getCC)

	cd build/gmake.unix
	emake config=${myconfig} verbose=true || die "make failed"

	if use doc; then
		cd "${S}"
		doxygen -u doxyfile &> /dev/null || die "updating doxygen config failed"
		doxygen doxyfile || die "creating docs failed"
	fi
}

src_test() {
	use debug && myconfig="debug" || myconfig="release"
	cd "${S}"/tests
	sed -i -e "s:debug:${myconfig}:" test
	./test || die "tests failed"
}

src_install() {
	use debug && myconfig="debug" || myconfig="release"
	exeinto /usr/bin
	doexe "${S}"/bin/${myconfig}/premake4 || die "exe install failed"

	if use doc; then
		insinto /usr/share/doc/${PF}
		dohtml -r "${S}"/doc/html/* || die "html install failed"
	fi

	dodoc BUILD.txt CHANGES.txt README.txt
}
