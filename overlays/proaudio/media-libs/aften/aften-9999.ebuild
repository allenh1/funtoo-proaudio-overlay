# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils git-2

DESCRIPTION="An A/52 (AC-3) audio encoder"
HOMEPAGE="http://${PN}.sourceforge.net/"
EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS=""
IUSE="cxx"

DEPEND=""
RDEPEND=""

DOCS=( README Changelog )

src_configure() {
	local mycmakeargs="-DSHARED=1"
	use cxx && mycmakeargs="${mycmakeargs} -DBINDINGS_CXX=1"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# File collision with media-sound/wavbreaker, upstream informed
	mv "${D}/usr/bin/wavinfo" "${D}/usr/bin/wavinfo-${PN}"
}
