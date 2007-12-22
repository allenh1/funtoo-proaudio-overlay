# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs exteutils lash

IUSE="alsa oss lash"

DESCRIPTION="A virtual MIDI keyboard for X"
HOMEPAGE="http://www.alsa-project.org/~iwai/alsa.html"
SRC_URI="http://www.alsa-project.org/~iwai/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.5.0 )
	>=dev-lang/tk-8.3
	lash? ( >=media-sound/lash-0.3.1 )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xf86bigfontproto
	x11-proto/bigreqsproto
	x11-proto/xextproto
	x11-proto/xcmiscproto"

S="${WORKDIR}"/${PN}

pkg_setup() {
	TCL_VERSION=`echo 'puts [info tclversion]' | tclsh`

	myconf="PREFIX=/usr"

	#vkeybd requires at least one of its USE_ variable to be set
	if use alsa ; then
		myconf="${myconf} USE_ALSA=1"
		use oss || myconf="${myconf} USE_AWE=0 USE_MIDI=0"
	else
		myconf="${myconf} USE_ALSA=0 USE_AWE=1 USE_MIDI=1"
	fi

	if use lash ; then
		myconf="${myconf} USE_LASH=1"
	fi

	myconf="${myconf} TCL_VERSION=${TCL_VERSION}"
	myconf="${myconf} CC=$(tc-getCC)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	if use lash ; then
		ladcca_to_lash
		esed_check -i -e "s/USE_LASH *=.*$/USE_LASH = 1/" Makefile 
		epatch "${FILESDIR}/lash-enabled-default.patch"
	fi

	# add our CFLAGS and LDFLAGS
	esed_check -i -e  "s@\(^CFLAGS\)\ *\=@\1 =  \$(EXTRACFLAGS)@g" \
		-e "s@\(\$(CC)\)@\1 \$(LDFLAGS)@g" Makefile
}

src_compile() {
	emake ${myconf} EXTRACFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed."
}

src_install() {
	emake ${myconf} DESTDIR="${D}" install-all || die "emake install failed."
	dodoc README ChangeLog
}
