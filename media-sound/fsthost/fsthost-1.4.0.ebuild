# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base toolchain-funcs multilib

DESCRIPTION="Official fork of FreeST, standalone Linux VST host - hybrid using
winelib, JACK and Gtk+"
HOMEPAGE="http://sourceforge.net/projects/fsthost/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="lash"

CDEPEND="app-emulation/wine
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit
	x11-libs/gtk+:2
	lash? ( media-sound/lash )"
#	lash? ( virtual/liblash )"
RDEPEND="${CDEPEND}
	gnome-extra/zenity"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=(README)

src_prepare() {
	# prevent illegal instruction in wine dialog when there is no sse2 available
	sed -i -e "s/-mfpmath=sse//" -e "s/-msse2//" Makefile || die
}

src_compile() {
	# need to fix libdir on amd64
	base_src_make CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		LINK="winegcc ${LDFLAGS}" \
		LIB_INST_PATH="${EPREFIX}"/usr/$(get_libdir)/wine \
		$(use lash && echo "LASH_EXISTS=yes" || echo "LASH_EXISTS=no")
}

src_install() {
	# need to specify all args to stop compiling again on install
	base_src_install CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		LINK="winegcc ${LDFLAGS}" \
		LIB_INST_PATH="${EPREFIX}"/usr/$(get_libdir)/wine \
		$(use lash && echo "LASH_EXISTS=yes" || echo "LASH_EXISTS=no")
}
