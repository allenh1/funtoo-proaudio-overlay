# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils toolchain-funcs

DESCRIPTION="Gsampler is a Linuxsampler Frontend"
HOMEPAGE="http://sourceforge.net/projects/gsampler/"
SRC_URI="http://downloads.sourceforge.net/project/$PN/$PN-$PV.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sqlite"

DEPEND="
	sqlite? ( media-sound/linuxsampler[sqlite] )
	!sqlite? ( media-sound/linuxsampler )
	sys-devel/gettext
	>=dev-lang/perl-5.8.1
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

DOCS=( README NEWS AUTHORS ChangeLog )

PATCHES=(
	"$FILESDIR/$P-gcc47.patch"
	"$FILESDIR/$P-doc.patch"
	"$FILESDIR/$P-desktop.patch"
)

AUTOTOOLS_AUTORECONF=1

src_configure() {
	autotools-utils_src_configure \
	GTK_LIBS="$($(tc-getPKG_CONFIG) --libs gtk+-2.0)" \
	GTK_CFLAGS="$($(tc-getPKG_CONFIG) --cflags gtk+-2.0)"
}
