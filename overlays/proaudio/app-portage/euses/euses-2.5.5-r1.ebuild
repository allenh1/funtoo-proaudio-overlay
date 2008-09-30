# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs autotools unipatch-001

WANT_AUTOCONF="latest"

DESCRIPTION="look up USE flag descriptions fast"
HOMEPAGE="http://www.xs4all.nl/~rooversj/gentoo"
SRC_URI="http://www.xs4all.nl/~rooversj/gentoo/${P}.tar.bz2
	http://download.tuxfamily.org/proaudio/distfiles/euses-overlay-patches-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cd "${S}"
	unpack ${A}
#	UNIPATCH_LIST=
#	unipatch
	EPATCH_SOURCE="$S" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch  
	eautoreconf
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1 || die
	dodoc ChangeLog || die
}
