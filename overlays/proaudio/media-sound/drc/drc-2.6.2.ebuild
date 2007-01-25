# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"

RESTRICT="nomirror"

DESCRIPTION="DRC generates digital room correction FIR filters to be used within HiFi systems in conjunction with real time convolution engines like BruteFIR."
HOMEPAGE="http://drc-fir.sourceforge.net"
SRC_URI="mirror://sourceforge/drc-fir/${P}-src.tar.gz
	doc? ( mirror://sourceforge/drc-fir/${P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove specific CFLAGS
	sed -i -e "s:^\(CFLAGS.*\):CFLAGS +=  -I. -I./getopt:" ${S}/source/makefile\
		|| die "cflags removal failed"
}

src_compile() {
	cd source
	emake || die
}

src_install() {
	cd ${S}/source
	dobin drc glsweep lsconv 

	cd ${S}
	dodoc readme.txt doc/text/drc.txt
	use doc && dohtml -r doc/html/./

	cd ${S}/sample
	insinto /usr/share/${PN}/sample
	doins *.txt *.drc
	#doins bk-2-sub.txt bk.txt dx32bit.pcm flat.txt optimized.drc strong.drc ultra.txt bk-2.txt ecm8000.txt normal.drc soft.drc subultra.txt wm-61a.txt
}

pkg_postinst() {
	einfo "Example config files are in /usr/share/drc/sample"
	einfo "Documentation is in /usr/share/doc/${P}/readme.txt.gz or"
	einfo "/usr/share/doc/${P}/html/drc.html"
	einfo "To use this package emerge media-sound/brutefir"
}
