# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

MY_P=GoatTracker_${PV}

DESCRIPTION="A tracker-like editor for creating C64 MOS 6581/8580 SID music"
HOMEPAGE="http://covertbitops.c64.org/"
SRC_URI="mirror://sourceforge/goattracker2/GoatTracker%202/${PV}/${MY_P}.zip"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=media-libs/libsdl-1.2.14[sound,video]"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"
# modified resid is bundled in the source tree

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.71-makefiles.patch"
	# don't strip binaries
	sed -i -e "s/strip/#strip/g" src/bme/makefile src/makefile.common || die
	# sed the arguments in the examples info, this is not windows
	sed -i -e "s|/|-|g" examples/goatcompo.txt || die

}

src_compile() {
	tc-export CC CXX
	cd src/bme
	emake || die "compile src/bme failed"
	cd ..
	emake || die "compile src failed"
}

src_install() {
	dobin linux/{betaconv,goattrk2,ins2snd2,mod2sng,sngspli2} || die

	dodoc authors readme.txt goat_tracker_commands.pdf

	doicon "${FILESDIR}/goattrk2.xpm"
	make_desktop_entry goattrk2 GoatTracker goattrk2 "AudioVideo;Audio;"

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins examples/*.{ins,sng,txt}
	fi
}
