# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="liblscp is a C++ library for the Linux Sampler control protocol."
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="mirror://sourceforge/qsampler/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "einstall failed"
}
