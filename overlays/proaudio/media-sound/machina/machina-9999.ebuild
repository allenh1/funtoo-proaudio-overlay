# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

DESCRIPTION="A polyphonic MIDI sequencer based on probabilistic finite-state automata"
HOMEPAGE="http://drobilla.net/software/machina/"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug doc"

RDEPEND=">=dev-cpp/glibmm-2.14.0:2
	>=dev-cpp/gtkmm-2.14.0:2
	>=dev-cpp/libglademm-2.6.0:2
	>=dev-libs/sord-0.5
	>=media-libs/raul-9999
	>=x11-libs/flowcanvas-9999
	>=media-sound/jack-audio-connection-kit-0.109.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" "${PN}/wscript" \
		"${PN}/src/client/wscript" "${PN}/src/engine/wscript" || die
}

src_configure() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure \
		$(use debug && echo "--debug") \
		$(use doc && echo "--docs")
}

src_compile() {
	cd ${PN}
	waf-utils_src_compile
}

src_install() {
	cd ${PN}
	waf-utils_src_install
	dodoc AUTHORS README THANKS

	if use doc; then
		mv "${D}/usr/share/doc/${PN}/html" "${D}/usr/share/doc/${PF}"
		rmdir "${D}/usr/share/doc/${PN}"
		find "${D}/usr/share/doc/" -name '*.md5' -delete
	fi
}
