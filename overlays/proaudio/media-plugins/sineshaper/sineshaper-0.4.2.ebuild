# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

inherit eutils
#MY_P="ll-scope-${PV}"
DESCRIPTION="A monophonic synth plugin that sends the sound from two sine
oscillators through two sine waveshapers in series (DSSI-Plugin)"
HOMEPAGE="http://www.student.nada.kth.se/~d00-llu/music_dssi.php?lang=en"
SRC_URI="http://ll-plugins.sourceforge.net/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=media-libs/dssi-0.9
	>=dev-cpp/libglademm-2.6.0
	>=media-libs/liblo-0.18
	virtual/pkgconfig"

#S="${WORKDIR}/${MY_P}"
src_unpack() {
	unpack ${A}
	cd "${S}"
#	epatch "${FILESDIR}/makefile-destdir.patch"
}

src_compile() {
	econf || die
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README ChangeLog
}
