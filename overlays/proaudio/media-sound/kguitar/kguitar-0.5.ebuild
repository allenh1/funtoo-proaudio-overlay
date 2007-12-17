# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

need-kde 3

RESTRICT=nomirror
DESCRIPTION="An efficient and easy-to-use environment for a guitarist"
HOMEPAGE="http://kguitar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"

IUSE="midi tetex"

DEPEND="midi? ( >=media-libs/tse3-0.2.3 )
        tetex? ( app-text/tetex )"

SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	use tetex && epatch ${FILESDIR}/tetex_sandbox.patch
	sed -i -e 's:\(\$(mkinstalldirs)\)\(.*\)\($(TEXMF)/tex/generic/kgtabs\):\1 $(DESTDIR)\3:' -e 's:\(\$(INSTALL_DATA).*$(srcdir)/kgtabs.tex\ *\):\1 $(DESTDIR):' kguitar_shell/Makefile.in
	sed -i -e 's:\(^TEXMF.*\=\)\(.*\):\1 /usr/share/texmf:' kguitar_shell/Makefile.in
}

src_compile() {
	myconf="$(use_with midi tse3) $(use_with tetex kgtabs)"
	kde_src_compile
}

src_install() {
	kde_src_install
}

pkg_postinst() {
	if use tetex ; then
		einfo "Running texhash"
		texhash
	fi
}
