# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Modular audio processing ssytem using JACK and LV2 or LADSPA plugins"
HOMEPAGE="http://drobilla.net/software/ingen"
SRC_URI=""

LICENSE="AGPL-3"
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
