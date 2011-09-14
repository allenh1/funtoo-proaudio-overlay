# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc double-precision" # oourafft"

RESTRICT="mirror"

DESCRIPTION="DRC generates digital room correction FIR filters to be used within HiFi systems in conjunction with real time convolution engines like BruteFIR."
HOMEPAGE="http://drc-fir.sourceforge.net"
SRC_URI="mirror://sourceforge/drc-fir/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove specific CFLAGS
	sed -i -e "s:^\(CFLAGS.*\):CFLAGS +=  -I. -I./getopt:" ${S}/source/makefile\
		|| die "cflags removal failed"
	if use double-precision ; then
		sed -i -e 's:^\(CFLAGS.*\):\1 -DUseDouble:' ${S}/source/makefile\
		|| die "douvle precision setting failed"
	fi
	# fail to compile here
#	if use oourafft ; then
#		sed -i -e 's:define UseGSLFft:define UseOouraFft:' ${S}/source/drc.h\
#		|| die "Enabling OouraFft failed"
#	fi
}

src_compile() {
	cd source
	emake || die "compilation failed"
}

src_install() {
	cd ${S}/source
	dobin drc glsweep lsconv

	cd ${S}
	dodoc readme.txt doc/text/drc.txt
	use doc && dohtml -r doc/html/./

	cd ${S}/sample
	insinto /usr/share/${PN}/sample
	doins *.txt *.drc *.pcm
}

pkg_postinst() {
	einfo "Example config files are in /usr/share/drc/sample"
	einfo "Documentation is in /usr/share/doc/${P}/readme.txt.gz or"
	einfo "/usr/share/doc/${P}/html/drc.html"
	einfo "To use this package emerge media-sound/brutefir"
}
