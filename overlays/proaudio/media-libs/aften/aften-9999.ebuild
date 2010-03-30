# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cmake-utils git

DESCRIPTION="An A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
EGIT_REPO_URI="git://aften.git.sourceforge.net/gitroot/aften/aften"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS=""
IUSE="cxx"
DEPEND=""

src_compile() {
	local mycmakeargs="-DSHARED=1"
	use cxx && mycmakeargs="${mycmakeargs} -DBINDINGS_CXX=1"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc README Changelog
	# File collision with media-sound/wavbreaker, upstream informed
	mv "${D}/usr/bin/wavinfo" "${D}/usr/bin/wavinfo-aften"
}
