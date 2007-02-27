# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/vkeybd/vkeybd-0.1.17-r1.ebuild,v 1.1 2006/04/10 18:03:32 gimpel Exp $

IUSE="alsa oss lash"

inherit lash eutils
DESCRIPTION="A virtual MIDI keyboard for X"
HOMEPAGE="http://www.alsa-project.org/~iwai/alsa.html"
SRC_URI="http://www.alsa-project.org/~iwai/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.5.0 )
	>=dev-lang/tk-8.3
	lash? ( >=media-sound/lash-0.3.1 )
	|| ( x11-libs/libX11 virtual/x11 )"

DEPEND="${RDEPEND}
	|| ( ( x11-proto/xf86bigfontproto
			x11-proto/bigreqsproto
			x11-proto/xextproto
			x11-proto/xcmiscproto )
		virtual/x11 )"

src_unpack() {
	unpack ${P}.tar.gz
	ladcca_to_lash
	cd ${S}
	use lash && epatch "${FILESDIR}/lash-enabled-default.patch"
}

src_compile() {
	TCL_VERSION=`echo 'puts [info tclversion]' | tclsh`

	local myconf="PREFIX=/usr"

	#vkeybd requires at least one of its USE_ variable to be set
	if use alsa ; then
		myconf="${myconf} USE_ALSA=1"
		use oss || myconf="${myconf} USE_AWE=0 USE_MIDI=0"
	else
		myconf="${myconf} USE_ALSA=0 USE_AWE=1 USE_MIDI=1"
	fi

	if use lash ; then
		myconf="${myconf} USE_LASH=1"
		sed -i "s/USE_LASH *=.*$/USE_LASH = 1/" ${S}/Makefile || \
			die "Error altering Makefile"
	fi

	make ${myconf} TCL_VERSION=$TCL_VERSION || die "Make failed."
}

src_install() {
	make DESTDIR=${D} TCL_VERSION=$TCL_VERSION PREFIX=/usr install || \
		die "Installation Failed"
	make DESTDIR=${D} TCL_VERSION=$TCL_VERSION PREFIX=/usr install-man || \
		die "Man-Page Installation Failed"
	dodoc README
}
