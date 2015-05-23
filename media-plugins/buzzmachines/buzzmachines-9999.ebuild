# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils git-2

DESCRIPTION="Machines for Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI=""
EGIT_REPO_URI="git://buzzmachines.git.sourceforge.net/gitroot/buzzmachines/buzzmachines"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=">=media-libs/bml-0.3.0"

DOCS=(ChangeLog HACKING NEWS README TODO)

AUTOTOOLS_AUTORECONF=1

pkg_postinst() {
	elog "Please see the README on how to set up environment variables etc."
	elog "The machines got installed to /usr/$(get_libdir)/Gear"
}
