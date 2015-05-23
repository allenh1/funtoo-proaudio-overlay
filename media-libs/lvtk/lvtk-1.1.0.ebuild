# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit python-single-r1 waf-utils

RESTRICT="mirror"
DESCRIPTION="A set C++ wrappers around the LV2 C API."
HOMEPAGE="http://lvtoolkit.org/"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples tools ui"

RDEPEND="media-libs/lv2
	>=dev-cpp/gtkmm-2.4
	>=dev-libs/boost-1.40.0"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mywafconfargs=(
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
		"--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2"
	)
	use debug && mywafconfargs+=( "--debug" )
	use doc && mywafconfargs+=( "--docs" )
	use examples || mywafconfargs+=( "--disable-examples" )
	use tools || mywafconfargs+=( "--disable-tools" )
	use ui || mywafconfargs+=( "--disable-ui" )
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	waf-utils_src_install

	# It does not respect docdir properly, reported upstream
	if use doc; then
		mv "${ED}/usr/share/doc/${PF}/lvtk-1.0/html" "${ED}/usr/share/doc/${PF}/html"
		rmdir "${ED}/usr/share/doc/${PF}/lvtk-1.0"
	fi
}
