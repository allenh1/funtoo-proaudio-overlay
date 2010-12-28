# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit subversion autotools toolchain-funcs multilib

DESCRIPTION="Ingen is a modular synthesizer using the Jack audio server and LV2 or LADSPA plugins."
HOMEPAGE="http://drobilla.net/software/ingen"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug doc ladspa osc soup"

RDEPEND=">=dev-cpp/libglademm-2.6.0
	>=dev-libs/libxml2-2.6
	>=dev-libs/redlandmm-9999
	>=media-libs/alsa-lib-1.0.0
	>=media-libs/raul-9999
	>=media-libs/slv2-9999
	>=media-sound/jack-audio-connection-kit-0.109.0
	>=x11-libs/flowcanvas-9999
	ladspa? ( media-libs/ladspa-sdk )
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
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" \
		./waf configure --prefix=/usr --libdir=/usr/$(get_libdir)/ \
		--module-dir=/usr/$(get_libdir)/ingen \
		$(! use ladspa && echo " --no-ladspa") \
		$(! use osc && echo " --no-osc") \
		$(! use soup && echo " --no-http") \
		$(use debug && echo " --debug") \
		$(use doc && echo " --docs --htmldir=/usr/share/doc/${P}/html") \
		|| die "waf configure failed"
}

src_compile() {
	cd ${PN}
	./waf build || die
}

src_install() {
	cd ${PN}
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS README THANKS
}
