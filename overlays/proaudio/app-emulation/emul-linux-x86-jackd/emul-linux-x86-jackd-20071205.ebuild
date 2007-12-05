# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="emul package for jack audio connection kit"
HOMEPAGE="http://gimpel.ath.cx/~tom/distfiles/"
SRC_URI="http://gimpel.ath.cx/~tom/distfiles/${P}.tbz2"

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="media-sound/jack-audio-connection-kit"


pkg_setup() {
	echo
	ewarn "This ebuild has been compiled on an AMD processor with"
	ewarn "CFLAGS=\"-march=k8 -msse3 -O2 -pipe -fomit-frame-pointer\""
	ewarn "LDFLAGS=\"-Wl,-O1 -Wl,--hash-style=gnu -Wl,--sort-common\""
	ewarn "and will most likely blow away your roof, kill your cat and"
	ewarn "make your wife run away with some other dude!"
	echo
	ewarn "Also it will overwrite libjack from soundlins emul,"
	ewarn "so use FEATURES=\"-collision-protect\"."
	sleep 10
	echo

	if ! built_with_use media-sound/jack-audio-connection-kit netjack; then
		eerror "You need to compile jack-audio-connection-kit with"
		eerror "USE=\"netjack\""
		die
	fi
}

src_install() {
	mv usr "${D}"/usr
}

pkg_postinst() {
	echo
	ewarn "This ebuild has been compiled on an AMD processor with"
	ewarn "CFLAGS=\"-march=k8 -msse3 -O2 -pipe -fomit-frame-pointer\""
	ewarn "LDFLAGS=\"-Wl,-O1 -Wl,--hash-style=gnu -Wl,--sort-common\""
	ewarn "and will most likely blow away your roof, kill your cat and"
	ewarn "make your wife run away with some other dude!"
	echo

	einfo "To run a 32bit and 64bit instance of jack in parallel:"
	echo
	einfo "In Terminal window A:"
	einfo "$ jackd -dalsa -R &"
	einfo "$ jacknet_client -p localhost"
	echo
	einfo "In Termina window B:"
	einfo "$ export export JACK_DEFAULT_SERVER=\"jackd32\""
	einfo "$ jackd32 -d net &"
	echo
	einfo "You HAVE TO export JACK_DEFAULT_SERVER for every 32bit jack"
	einfo "application you want to start, otherwhise they try to connect"
	einfo "to the default (64bit) instance!"
}
