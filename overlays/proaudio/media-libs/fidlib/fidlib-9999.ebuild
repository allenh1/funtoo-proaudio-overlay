# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils flag-o-matic git-r3

DESCRIPTION="Run-time filter design and execution library"
HOMEPAGE="http://uazu.net/fidlib/"
EGIT_REPO_URI="git://github.com/JamesHight/fidlib.git"
EGIT_BRANCH="master"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

src_prepare() {
	# Avoid ICE under gcc-4.6, fixed in 4.6.3
	if [[ $(gcc-version) == "4.6" && $(gcc-micro-version) -le 2 ]] ; then
		replace-flags -O? -O0
	fi

	autotools-utils_src_prepare
}
