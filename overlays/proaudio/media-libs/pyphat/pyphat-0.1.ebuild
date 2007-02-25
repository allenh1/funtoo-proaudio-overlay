# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="python binding for phat"
HOMEPAGE="http://phat.berlios.de/"

#ESVN_REPO_URI="svn://svn.berlios.de/phat/trunk/pyphat"
SRC_URI="http://download.berlios.de/phat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

#S="${WORKDIR}/${PN}"

IUSE=""
DEPEND=">=media-libs/phat-0.4"

src_unpack() {
#subversion_src_unpack ${A}
	unpack "${A}"
	cd "${S}"
	#chmod +x autogen.sh
	#./autogen.sh
}

src_compile() {
	econf || die "Configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS || die "dodoc failed"
}
