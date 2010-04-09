# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib subversion

RESTRICT="mirror"
IUSE="debug doc"
DESCRIPTION="Realtime Audio Utility Library: lightweight header-only C++"
HOMEPAGE="http://wiki.drobilla.net/Raul"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND=">=dev-libs/glib-2.14.0
	>=dev-cpp/glibmm-2.14.0"
DEPEND="dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_compile() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"

	local myconf="--prefix=/usr"

	use doc && myconf="${myconf} --build-docs --htmldir=/usr/share/doc/${P}/html"
	use debug && myconf="${myconf} --debug"

	./waf configure ${myconf} || die "configure failed"
	./waf build ${MAKEOPTS} || die "waf failed"
}

src_install() {
	cd "${S}/${PN}" || die "cd to ${S}/${PN} failed"
	# addpredict for the ldconfig
	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog
}
