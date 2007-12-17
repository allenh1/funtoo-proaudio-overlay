# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="GTK+ graphical music notation editor"
HOMEPAGE="http://denemo.sourceforge.net/"
SRC_URI="mirror://sourceforge/denemo/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="alsa csound midi nls pic plugins gtk2"

RDEPEND=">=x11-libs/gtk+-2.6.0
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-util/yacc
	>=sys-devel/flex-2.5.4a
	sys-devel/gettext
	>=sys-devel/bison-1.35
	>=media-sound/lilypond-2.0
	alsa? ( media-libs/alsa-lib )
	csound? ( media-sound/csound )
	midi? ( media-sound/timidity++ )"

src_compile() {
	append-flags -fpermissive

	use plugins && local myconf="${myconf} --with-plugins='analysis'
		--with-plugins='midiinput --with-plugins='rumour'"
	econf "$(use_enable gtk2 use_enable alsa
		use_enable pic use_enable nls) ${myconf}" || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
