# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Synthesizer keyboard emulation package: Moog, Hammond and others"
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa oss X"
# osc : configure option but no code it seems...
# jack: fails to build if disabled

RDEPEND=">=media-sound/jack-audio-connection-kit-0.109.2
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	X? ( x11-libs/libX11 )"
# osc? ( >=media-libs/liblo-0.22 )
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )
	dev-util/pkgconfig"

src_compile() {
	# fix mandir
	sed -e "s/ \$(mandir)/ \$(DESTDIR)\$(mandir)/" -i Makefile.am
	sed -e "s/ \$(mandir)/ \$(DESTDIR)\$(mandir)/" -i Makefile.in
	#without this option configuration failed if bristol has been already installed
	local myconf="${myconf} --disable-version-check"
	if ! use X; then
		myconf="${myconf} --disable-x11 --disable-ximage"
	fi
	econf \
		$(use_enable alsa) \
		$(use_enable oss) \
		${myconf} || die "econf failed"
#		$(use_enable osc liblo)
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
