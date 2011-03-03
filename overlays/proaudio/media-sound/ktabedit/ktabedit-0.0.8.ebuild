# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
# TODO: this ebuild needs some kde eclass work -- will not function
#inherit kde

MY_PV=${PV/b/-b}

DESCRIPTION="KTabEdit is basically a guitar tabulature editor for K Desktop Environment."
DESCRIPTION_FR="Editeur de tablature."
HOMEPAGE="http://ktabedit.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktabedit/${PN}-${MY_PV}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="-*"

IUSE="arts debug xinerama"
SLOT="0"
S=${WORKDIR}/${PN}

DEPEND="media-libs/tse3"
#need-kde 3.2

src_compile() {
	econf $(use_with arts) \
		$(use_with debug) \
		$(use_with xinerama) || die "configure failed!"
	make pch || die "make pch failed"
	emake || die "make failed"
}
