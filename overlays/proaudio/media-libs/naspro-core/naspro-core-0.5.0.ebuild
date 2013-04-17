# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools-utils

DESCRIPTION="Portable runtime library at the bottom of the NASPRO Sound PROcessing Architecture"
HOMEPAGE="http://naspro.sourceforge.net/"
SRC_URI="mirror://sourceforge/naspro/naspro/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RESTRICT="mirror"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
