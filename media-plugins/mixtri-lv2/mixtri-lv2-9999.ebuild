# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base git-2 multilib

DESCRIPTION="MixTri(x) is a matrix mixer and trigger processor intended to de used with sisco-lv2"
HOMEPAGE="http://x42.github.io/mixtri.lv2"
SRC_URI=""
EGIT_REPO_URI="git://github.com/x42/mixtri.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/lv2
	media-libs/libltc
	x11-libs/gtk+:2
	x11-libs/pango
	x11-libs/cairo
	virtual/opengl"
RDEPEND=""

DOCS=( README.md )

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	make submodules
}

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
	base_src_install_docs
}
