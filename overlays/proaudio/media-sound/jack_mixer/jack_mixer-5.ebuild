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
KEYWORDS="~x86"

# Not sure about the required swig version, report if 1.3.25 doesn't work
DEPEND="media-sound/jack-audio-connection-kit
	dev-python/pygtk
	dev-python/fpconst
	>=dev-python/pyxml-0.8.4
	dev-python/gnome-python
	dev-python/fpconst
	media-libs/pyphat"
	# 1. only needed for non tarballs aka svn checkouts >=dev-lang/swig-1.3.25
RDEPEND="${DEPEND}
	>=media-libs/pylash-3_pre"

pkg_setup() {
	ewarn "please make sure you're using latest jack-audio-connection-kit svn"	
	# 2. don't know if this is still valid refered to 1.
	#if ! built_with_use swig python ; then
	#	eerror "Please re-emerge swig with USE='python'"
	#	die
	#fi
}

src_unpack() {
	unpack ${A}
#	epatch ${FILESDIR}/${P}-destdir.patch
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	gnome2_src_install
#	make DESTDIR="${D}" install || die
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS CHANGES README
	
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
