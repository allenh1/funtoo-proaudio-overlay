# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base git-2 multilib

DESCRIPTION="LV2 audio delay line with latency reporting"
HOMEPAGE="http://github.com/x42/nodelay.lv2"
SRC_URI=""
EGIT_REPO_URI="git://github.com/x42/nodelay.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/lv2"
RDEPEND=""

DOCS=( README )

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
	base_src_install_docs
}
