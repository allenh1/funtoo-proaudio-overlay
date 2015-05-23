# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="C library to make the use of LV2 plugins as simple as possible for applications."
HOMEPAGE="http://drobilla.net/software/lilv"
SRC_URI=""

LICENSE="ISC"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

pkg_postinst() {
	einfo "This ebuild is a fake aimed to satisfy portage dependencies"
	einfo "without creating circular dependencies."
	einfo "Nothing will be installed."
	einfo ""
	elog "To install ${P}, please emerge media-sound/drobilla"
}
