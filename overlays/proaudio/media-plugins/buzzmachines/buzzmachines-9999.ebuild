# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib subversion

DESCRIPTION="Machines for Buzztard"
HOMEPAGE="http://www.buzztard.org"

ESVN_REPO_URI="https://buzztard.svn.sourceforge.net/svnroot/buzztard/trunk/${PN}"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=media-libs/bml-0.3.0"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable debug) \
		|| die "Configure failed"
}

#src_compile() {
#	emake || die "Compilation failed"
#}

src_install() {
	einstall || die "Install failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	elog "Please see the README on how to set up environment variables etc."
	elog "The machines got installed to /usr/$(get_libdir)/Gear"
}
