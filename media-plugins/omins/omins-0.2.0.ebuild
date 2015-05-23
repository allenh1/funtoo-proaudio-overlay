# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils autotools

RESTRICT="mirror"
DESCRIPTION="Collection of LADSPA plugins for modular synthesizers."
HOMEPAGE="http://www.nongnu.org/om-synth/omins.html"
SRC_URI="http://savannah.nongnu.org/download/om-synth/${P}.tar.gz"

IUSE="debug"
LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	esed_check -i -e 's#$libdir/ladspa#\\$\\(DESTDIR\\)$libdir/ladspa#' \
		configure.ac
	eautoreconf
}

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# "emake install" does sandbox violations, so we use einstall
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog NEWS README
}
