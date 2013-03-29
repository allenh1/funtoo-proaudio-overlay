# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="library for serialising LV2 atoms to/from RDF"
HOMEPAGE="http://drobilla.net/software/sratom"
SRC_URI=""

LICENSE="MIT"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_postinst() {
	einfo "This ebuild is a fake aimed to satisfy portage dependencies"
	einfo "without creating circular dependencies."
	einfo "Nothing will be installed."
	einfo ""
	elog "To install ${P}, please emerge media-sound/drobilla"
}
