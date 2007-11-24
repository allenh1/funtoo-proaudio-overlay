# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
DESCRIPTION="a minimalistic plugin API for video effects"
HOMEPAGE="http://www.piksel.org/frei0r"
SRC_URI="http://propirate.net/frei0r/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""


src_install(){
	 emake DESTDIR="${D}" install || die "Install failed"
}
