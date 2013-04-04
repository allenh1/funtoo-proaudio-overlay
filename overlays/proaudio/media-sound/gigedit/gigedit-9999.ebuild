# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
AUTOTOOLS_AUTORECONF=1
inherit subversion autotools-utils

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/gigedit/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	>=media-libs/libgig-9999
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-9999"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README)

src_compile() {
	autotools-utils_src_compile -j1
}

src_install() {
	autotools-utils_src_install
	make_desktop_entry "${PN}" GigEdit "${PN}" "AudioVideo;Audio;Player;Midi;"
}
