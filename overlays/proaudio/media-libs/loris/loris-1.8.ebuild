# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit flag-o-matic

DESCRIPTION="libraries that provide support for the Resource Description Framework (RDF)"
HOMEPAGE="http://www.hakenaudio.com/Loris"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc fftw python csound"

DEPEND="fftw? ( sci-libs/fftw )
	python? ( dev-lang/python
		dev-lang/swig )
	csound? ( >=media-sound/csound-5.0 )
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

src_configure() {
	append-cppflags -I /usr/include/csound
	econf \
		$(use_with fftw) \
		$(use_with python) \
		$(use_with csound csound5) || die "econf failed"
}

src_install(){
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS README doc/opcodes.html doc/utils.html

	if use doc; then
		insinto /usr/share/doc/${P}/html
		doins doc/html/* || die "install doc failed"
	fi
}
