# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="System tray utility including support for KDE system tray icons."

HOMEPAGE="http://stalonetray.sourceforge.net/"

SRC_URI="http://puzzle.dl.sourceforge.net/sourceforge/stalonetray/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86 ~amd64"

IUSE="kde"

DEPEND=">=x11-base/xorg-x11-7.0-r1"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/disable_native_kde_build_fix.patch" || die "Patch native kde failed"
	cd ${S}/src
	epatch "${FILESDIR}/invalid_placement_fix.patch" || die "Patch placement failed"
}

src_compile() {
	local myconf
	cd ${S}
	
	if ! use kde; then
		myconf="--disable-native-kde"
	fi

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README stalonetrayrc.sample TODO
	dohtml stalonetray.html
}
