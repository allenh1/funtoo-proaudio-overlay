# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="python binding for phat"
HOMEPAGE="http://phat.berlios.de/"

ESVN_REPO_URI="svn://svn.berlios.de/phat/trunk/pyphat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE=""
DEPEND="=media-libs/phat-9999"

src_unpack() {
	subversion_src_unpack ${A}
	cd "${S}"
	chmod +x autogen.sh
	./autogen.sh
}

src_compile() {
	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS || die "dodoc failed"
}
