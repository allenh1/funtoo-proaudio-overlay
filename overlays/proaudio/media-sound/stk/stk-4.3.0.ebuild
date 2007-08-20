# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa jack midi oss"

DEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( media-sound/jack-audio-connection-kit )
		midi? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		`use_with alsa` \
		`use_with jack` \
		`use_with oss` \
		|| die "configure failed!"

	cd src
	emake || die "make failed!"
}

src_install() {
	cd "${S}/src"
	make DESTDIR="${D}" install || die "make install failed!"
	cd ..
	dodoc README STK_TODO.txt
}

