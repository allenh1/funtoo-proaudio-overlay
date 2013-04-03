# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
AUTOTOOLS_AUTORECONF=1
# bug
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit subversion autotools-utils

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features."
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/linuxsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa doc dssi jack lv2 sqlite static-libs"
REQUIRED_USE="|| ( alsa jack )"

# media-libs/dssi, media-libs/lv2 automagic
RDEPEND=">=media-libs/libgig-9999
	alsa? ( media-libs/alsa-lib )
	dssi? ( media-libs/dssi )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( media-libs/lv2 )
	sqlite? ( >=dev-db/sqlite-3.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local myeconfargs=(
		$(use_enable alsa alsa-driver)
		--disable-arts-driver
		$(use_enable jack jack-driver)
		$(use_enable sqlite instruments-db)
		$(use_enable static-libs static)
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile -j1
	use doc && autotools-utils_src_compile -j1 docs
}

src_install() {
	use doc && HTML_DOCS=("${BUILD_DIR}"/doc/html/)
	autotools-utils_src_install
}
