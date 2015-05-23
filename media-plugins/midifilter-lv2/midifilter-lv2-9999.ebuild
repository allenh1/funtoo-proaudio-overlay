# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base git-2 multilib

DESCRIPTION="LV2 plugins to filter MIDI events"
HOMEPAGE="http://github.com/x42/midifilter.lv2"
SRC_URI=""
EGIT_REPO_URI="git://github.com/x42/midifilter.lv2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/lv2"
RDEPEND=""

DOCS=( AUTHORS README.md )

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
	base_src_install_docs
}
