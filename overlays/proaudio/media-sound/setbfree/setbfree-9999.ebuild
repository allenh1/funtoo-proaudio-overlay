# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bristol/bristol-0.60.10.ebuild,v 1.1 2012/06/30 05:54:41 radhermit Exp $

EAPI="4"

inherit eutils git-2

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"
EGIT_REPO_URI="https://github.com/pantherb/setBfree.git"

LICENSE="GPL-2
	CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS=""
IUSE="-convolution -custom-cflags"

RDEPEND="media-sound/jack-audio-connection-kit
	>=media-libs/alsa-lib-1.0.0
	media-libs/liblo
	media-libs/lv2
	convolution? ( media-libs/libsndfile
		media-libs/zita-convolver )
	dev-lang/tcl
	dev-lang/tk"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README.md )

my_conf=""
if use convolution ; then
	my_conf="ENABLE_CONVOLUTION=yes"
fi

src_prepare() {
	emake clean
}

src_compile() {
	if ! use custom-cflags ; then
		my_opts="OPTIMIZATIONS=${CFLAGS}"
	fi

	make ${my_conf} PREFIX=/usr "${my_opts}"
}

src_install() {
	make install ${my_conf} DESTDIR=${D} PREFIX=/usr
	doman doc/*.1
	insinto /usr/share/applications
	doins "$FILESDIR"/setbfree.desktop
	insinto /usr/share/pixmaps
	doins doc/setBfree.png
}

pkg_postinst() {
einfo "Use setBfree-start to run setBfree"
}
