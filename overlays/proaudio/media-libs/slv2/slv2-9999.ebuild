# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit multilib subversion

RESTRICT="mirror"
DESCRIPTION="SLV2 is a library for LV2 hosts "
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc jack"

RDEPEND="jack? ( >=media-sound/jack-audio-connection-kit-0.107.0 )
	>=media-libs/raptor-1.4.0
	>=dev-libs/redland-1.0.6
	>=media-libs/lv2core-2.0"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

src_prepare() {
	cd "${S}/${PN}" || die
	# not sure about this but works around compile failure
	sed -i -e "s|lv2/http/lv2plug.in/ns/ext/event/||" \
		hosts/event.lv2/event-helpers.h || die
}

src_configure() {
	cd "${S}/${PN}" || die
	tc-export CC CXX CPP AR RANLIB
	./waf configure --prefix=/usr --libdir=/usr/$(get_libdir) \
		$(use doc && echo " --build-docs --htmldir=/usr/share/doc/${P}/html") \
		$(use debug && echo "--debug") || die
}

src_compile() {
	cd "${S}/${PN}" || die
	./waf build || die
}

src_install() {
	cd "${S}/${PN}" || die
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc AUTHORS ChangeLog
}
