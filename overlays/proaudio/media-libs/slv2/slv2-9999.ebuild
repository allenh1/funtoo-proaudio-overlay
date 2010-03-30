# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion exteutils

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

src_compile() {
	cd "${S}/${PN}" || die "source for ${PN} not found"

	local myconf="--prefix=/usr --libdir=/usr/$(get_libdir)/"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die "configure failed"
	./waf build ${MAKEOPTS} || die "waf failed"
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog
}
