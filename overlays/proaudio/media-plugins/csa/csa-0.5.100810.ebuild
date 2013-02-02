# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools multilib
WANT_AUTOMAKE="1.11.1"

DESCRIPTION="Control Signal Audio. A group of LADSPA Audio plugins for FM broadcast and more"
HOMEPAGE="http://csa.sourceforge.net/index/index_en.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# fix multilib-strict
	sed -i -e "s|/lib/ladspa|/$(get_libdir)/ladspa|" src/Makefile.am || die
	eautomake
}

src_configure() {
	econf --disable-dependency-tracking || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README THANKS TODO

	# are the .la files needed?
	rm "${D}"/usr/$(get_libdir)/ladspa/*.la
}
