# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils git-2

DESCRIPTION="GStreamer plugin used by Buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI=""
EGIT_REPO_URI="git://buzztard.git.sourceforge.net/gitroot/buzztard/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +orc static-libs"

RDEPEND=">=media-libs/gstreamer-0.10.11:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	>=media-libs/bml-${PV}
	media-sound/fluidsynth
	orc? ( dev-lang/orc )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

AUTOTOOLS_AUTORECONF=1
# bug
AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(AUTHORS ChangeLog NEWS README TODO)

src_configure() {
	local myeconfargs=(
		$(use_enable doc gtk-doc-html)
		$(use_enable orc)
	)
	autotools-utils_src_configure
}
