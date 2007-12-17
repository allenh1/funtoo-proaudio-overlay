# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs autotools unipatch-001

WANT_AUTOCONF="latest"

DESCRIPTION="look up USE flag descriptions fast"
HOMEPAGE="http://www.xs4all.nl/~rooversj/gentoo"
SRC_URI="http://www.xs4all.nl/~rooversj/gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cd "${S}"
	unpack "${A}"
	UNIPATCH_LIST="${FILESDIR}/euses-overlay-patches.tar.gz"
	unipatch
	[ -e "${KPATCH_DIR}" ] && rm -rf "${KPATCH_DIR}"
	UNIPATCH_LIST="${FILESDIR}/euses-overlay-patches-2.tar.gz"
	unipatch
	eautoreconf
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1 || die
	dodoc ChangeLog || die
}
