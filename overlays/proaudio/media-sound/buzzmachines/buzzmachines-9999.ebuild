# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Machines for Buzztard"
HOMEPAGE="http://www.buzztard.org"

ESVN_REPO_URI="https://buzztard.svn.sourceforge.net/svnroot/buzztard/trunk/${PN}"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=media-libs/bml-0.3.0"
RDEPEND="${DEPEND}"

src_compile() {
	./configure
		--prefix=/usr/share/buzztard/machines \
		`use_enable debug` \
		|| die "Configure failed"
	emake || die "Compilation failed"
}

src_install() {
	einstall || die "Install failed"
	dodoc AUTHORS ChangeLog README
}
