# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit exteutils

IUSE="doc examples"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DESCRIPTION="Faust AUdio STreams is a functional programming language and compiler for fast DSP algorythms."
HOMEPAGE="http://faudiostream.sourceforge.net"
SRC_URI="mirror://sourceforge/faudiostream/${P}.zip"
#S=${WORKDIR}

RDEPEND="sys-devel/bison
	sys-devel/flex"
DEPEND="sys-apps/sed
	doc? ( app-doc/doxygen )"

src_compile() {
	PREFIX=/usr emake
	if use doc ; then
		make doc
	fi
}

src_install() {
	emake install PREFIX=/usr DESTDIR="${D}"
	dodoc README
	if use doc ; then
	    dodoc WHATSNEW documentation/*.pdf "documentation/additional documentation" \
		    documentation/touchOSC.txt
	    dohtml dox/html/*.html dox/html/*.png dox/html/*.css dox/html/*.js
	fi
	if use examples ; then
	    insinto /usr/share/"${P}"/examples
	    doins examples/*
	fi
}
