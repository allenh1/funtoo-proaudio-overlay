# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/museseq/museseq-0.8.1.ebuild,v 1.1 2006/04/10 11:08:06 gimpel Exp $

inherit kde-functions virtualx eutils toolchain-funcs
need-qt 3

MY_P=${P/museseq/muse}
MY_P=${MY_P/_/}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"
HOMEPAGE="http://lmuse.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="lash debug vst"

DEPEND=">=x11-libs/qt-3.2.0
	alsa? ( media-libs/alsa-lib )
	>=media-sound/fluidsynth-1.0.3
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.4
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash?		( >=media-sound/lash-0.4.0 )"

S="${WORKDIR}/${MY_P}"

src_unpack(){
	# check if libfst is valid
	if [ -e "/usr/lib/pkgconfig/libfst.pc"	];then
		egrep -q '1.8|1.7' /usr/lib/pkgconfig/libfst.pc &>/dev/null && \
		eerror "try to update fst: at least to fst-1.8-r3 or uninstall fst
 or just remove /usr/lib/pkgconfig/libfst.pc" && die
	fi	
	unpack ${A}
	cd  ${S}
}

src_compile() {
	./autogen.sh
	export LD="$(tc-getLD)"
	Xeconf \
		"`use_enable lash` \
		`use_enable debug` \
		`use_enable vst` \
		--disable-suid-install --enable-optimize \
		--disable-suid-build" || die "Configure failed"

	emake all || die
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README SECURITY README.*
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 0.8.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
}

