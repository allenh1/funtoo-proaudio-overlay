# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

IUSE=""

DESCRIPTION="MIDI monitor using ALSA sequencer and KDE user interface."
HOMEPAGE="http://kmetronome.sourceforge.net/kmidimon/"
SRC_URI="mirror://sourceforge/kmetronome/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
RESTRICT="nomirror"

RDEPEND=">=media-libs/alsa-lib-1.0
	kde-base/kdelibs"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.2
	sys-devel/gettext
	dev-util/pkgconfig"

need-kde 3

src_compile() {
	cmake . -DCMAKE_INSTALL_PREFIX=`kde-config --prefix`
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog
}
