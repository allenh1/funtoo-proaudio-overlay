# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_P=GoatTracker_${PV}

DESCRIPTION="A tracker-like music editor for creating C64 MOS 6581/8580 SID music"
HOMEPAGE="http://covertbitops.c64.org/"
SRC_URI="mirror://sourceforge/goattracker2/GoatTracker%202/${PV}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=media-libs/libsdl-1.2.14"
DEPEND="${DEPEND}
	app-arch/unzip"
# resid seems to be bundled in the source tree
#>=media-libs/resid-0.16_p2

S=${WORKDIR}
RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefiles.patch"
	# don't strip binaries
	sed -i -e "s/strip/#strip/g" src/bme/makefile src/makefile.common || die
}

src_compile() {
	tc-export CC CXX
	cd src/bme
	emake || die "compile src/bme failed"
	cd ..
	emake || die "compile src failed"
}

src_install() {
	pushd linux
	dobin betaconv goattrk2 ins2snd2 mod2sng sngspli2 || die
	popd

	dodoc authors readme.txt goat_tracker_commands.pdf

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		pushd examples
		doins *.ins *.sng *.txt
		popd
	fi
}
