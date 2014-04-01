# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base git-2 multilib

DESCRIPTION="convoLV2 is a lv2 plugin to convolve audio signals"
HOMEPAGE="http://github.com/x42/convoLV2"
SRC_URI=""
EGIT_REPO_URI="git://github.com/x42/convoLV2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/lv2
	media-libs/zita-convolver
	media-libs/libsndfile
	media-libs/libsndfile
	x11-libs/gtk+:2"
RDEPEND=""

DOCS=( README.md )

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
	base_src_install_docs
}
