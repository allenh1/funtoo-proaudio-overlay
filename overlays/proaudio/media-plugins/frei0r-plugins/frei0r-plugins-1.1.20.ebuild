# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

RESTRICT="mirror"
DESCRIPTION="a minimalistic plugin API for video effects"
HOMEPAGE="http://www.piksel.org/frei0r"
SRC_URI="http://propirate.net/frei0r/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack(){
	unpack ${A}
	cd "${S}/include"
	# gcc 4.3 include fix
	esed_check -i -e "s@\(#define INCLUDED_FREI0R_H\)@\1\n#include <string.h>\n#include <stdlib.h>@g" frei0r.h
}
src_install(){
	 emake DESTDIR="${D}" install || die "Install failed"
}
