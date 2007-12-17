# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnome2

IUSE=""
RESTRICT="nomirror"

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
SRC_URI="http://download.gna.org/jackmixer/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

# Not sure about the required swig version, report if 1.3.25 doesn't work
DEPEND="media-sound/jack-audio-connection-kit
	>=dev-lang/swig-1.3.25
	dev-python/pygtk
	dev-python/fpconst
	>=dev-python/pyxml-0.8.4
	dev-python/gnome-python
	media-libs/pylash
	media-libs/pyphat"

pkg_setup() {
	if ! built_with_use swig python ; then
		eerror "Please re-emerge swig with USE='python'"
		die
	fi
}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-destdir.patch
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dosym /usr/share/jack_mixer/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS CHANGES README

}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
