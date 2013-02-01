# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

RESTRICT="mirror"
IUSE=""
DESCRIPTION="foo-plugins for ladspa"
HOMEPAGE="http://code.google.com/p/foo-plugins/"
SRC_URI="http://foo-plugins.googlecode.com/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
