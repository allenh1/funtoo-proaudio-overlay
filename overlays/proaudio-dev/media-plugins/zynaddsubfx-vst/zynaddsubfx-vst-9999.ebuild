# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic

DESCRIPTION="VST version of ZynaddSubFX"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=8"
ESVN_REPO_URI="svn://jacklab.net/eXT2/vstplugins/zynaddsubfx"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/vst-sdk
	=sci-libs/fftw-3*
	dev-libs/mini-xml"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_fetch
	# fix Makefile to use our CXXFLAGS and correct include path
	sed -i -e "s:-march=i686 -pipe -O2 -fomit-frame-pointer:${CXXFLAGS}:" \
	${S}/src/Makefile || die "sed failed"
	# fix texrels
	sed -i -e "s:-fPIC:-fPIC -DPIC:g" ${S}/src/Makefile || die "sed failed"
	# copy over VST headers
	cp /usr/include/vst/* ${S}/vstsdk2/source/common/
}

src_compile() {
	# first we have to built the slightly modified fltk tree
	cd "${S}/fltk"
	emake || die "make in fltk failed"
	
	cd "${S}/src"
	# emake refuses to work here, also with -j1
	make || die "make failed"
}

src_install() {
	dodir /usr/lib/vst
	exeinto /usr/lib/vst
	doexe src/zynaddsubfx_vst.so
	dodoc ChangeLog README.txt HISTORY.txt
}
