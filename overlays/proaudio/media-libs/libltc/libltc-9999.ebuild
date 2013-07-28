# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

[[ "${PV}" = "9999" ]] && inherit git-2

AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_AUTORECONF="1"
inherit autotools-utils

if [[ "${PV}" = "9999" ]]; then
	EGIT_REPO_URI="git://github.com/x42/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://github.com/x42/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="mirror"

DESCRIPTION="Linear/Logitudinal Time Code (LTC) Library"
HOMEPAGE="https://github.com/x42/libltc"
LICENSE="GPL-3"
SLOT="0"

IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	autotools-utils_src_compile

	use doc && autotools-utils_src_compile dox
}

src_install() {
	use doc && HTML_DOCS=( doc/html/ )

	autotools-utils_src_install
}
