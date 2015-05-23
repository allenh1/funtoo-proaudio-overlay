# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base toolchain-funcs

DESCRIPTION="Real-time MIDI controllable virtual SID based synthesizer using the reSID emulation library"
HOMEPAGE="http://gp2x.org/remid/"
SRC_URI="http://gp2x.org/remid/reMID-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa gtk"

RDEPEND="dev-libs/glib:2
	media-libs/resid
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	gtk? ( gnome-base/libglade
		   x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/reMID-${PV}
RESTRICT="mirror"

DOCS=(README instruments.conf)

PATCHES=(
	"${FILESDIR}"/${P}-printf-include.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare() {
	base_src_prepare

	# assumed to execute from source directory so will fail finding the glade
	# file. the glade file is installed in src_install so this changes the
	# source to reflect that. probably better done in Makefile or some other way
	sed -i -e "s@reMID.glade@${EPREFIX}/usr/share/reMID/&@" src/gui.c || die
}

src_compile() {
	base_src_make \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		ALSA_MIDI=$(use alsa && echo yes || echo no) \
		GUI=$(use gtk && echo yes || echo no)
}

src_install() {
	dobin reMID

	insinto /usr/share/reMID
	doins reMID.glade

	base_src_install_docs
}
