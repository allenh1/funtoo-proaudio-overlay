# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""

inherit eutils toolchain-funcs 

DESCRIPTION="synthesiser emulation package for Moog, Sequential Circuits, Hammond and several other keyboards."
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa jack"

DEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
				virtual/x11 )
		media-libs/alsa-lib
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )"
		
src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i -e "s@bin/startBristol \$(prefix)/bin@bin/startBristol \$(DESTDIR)/\$(prefix)/bin@g" \
		Makefile.in
	sed -i -e "s@bristoldir = \${prefix}/bristol@bristoldir = \$(DESTDIR)/\${prefix}/share/bristol@g" \
		Makefile.in
}

src_compile() {
	econf \
		`use_enable alsa` \
		`use_enable jack` \
		|| die "configure failed"
	
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog AUTHORS README NEWS 
}
