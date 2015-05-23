# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cvs

DESCRIPTION="MPEG audio decoder."
HOMEPAGE="http://mpadec.sourceforge.net/"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	dev-vcs/cvs"

S="${WORKDIR}/${PN}"

src_unpack() {
	ECVS_SERVER="mpadec.cvs.sourceforge.net:/cvsroot/mpadec"
	ECVS_USER="anonymous"
	ECVS_PASS=""
	ECVS_AUTH="pserver"
	ECVS_MODULE="mpadec"
	ECVS_TOP_DIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"
	cvs_src_unpack
}

src_prepare() {
	if use amd64; then
		sed -i "s@#define ARCH_X86@//#define ARCH_X86@" config.h
		sed -i "s@//#define ARCH_AMD64@#define ARCH_AMD64@" config.h
	fi
}

src_compile() {
	emake || die
}

src_install() {
	dobin mpadec
	insinto /usr/include
	doins include/*.h
	dolib.a libmpadec/*.a
	dolib.so libmpadec/*.so
	dodoc README
}
