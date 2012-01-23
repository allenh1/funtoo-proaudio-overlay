# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

DESCRIPTION="Ingen is a modular synthesizer using the Jack audio server and LV2 plugins"
HOMEPAGE="http://drobilla.net/software/ingen"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug doc osc soup"

RDEPEND=">=dev-cpp/libglademm-2.6.0
	>=media-libs/alsa-lib-1.0.0
	>=media-libs/lilv-0.5.0
	>=media-libs/raul-9999
	>=dev-libs/sord-0.5
	>=dev-libs/suil-0.4.4
	|| ( >=media-sound/jack-audio-connection-kit-0.120.1
		 >=media-sound/jack-audio-connection-kit-1.9.7 )
	>=x11-libs/flowcanvas-9999
	osc? ( >=media-libs/liblo-0.22 )
	soup? ( >=net-libs/libsoup-2.4.0 )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	dev-util/pkgconfig"

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure \
		--module-dir=/usr/$(get_libdir)/ingen \
		$(! use osc && echo "--no-osc") \
		$(! use soup && echo "--no-http") \
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
