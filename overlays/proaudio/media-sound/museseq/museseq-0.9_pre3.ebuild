# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions eutils toolchain-funcs
need-qt 3

MY_P=${P/museseq/muse}
MY_P=${MY_P/_/}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="lash debug"

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
	lash? ( >=media-sound/lash-0.5.0 )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf \
		`use_enable lash` \
		`use_enable debug` \
		--disable-suid-install \
		--enable-optimize \
		--disable-suid-build \
		|| die "Configure failed"

	emake all || die
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README SECURITY README.*
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	echo
	einfo "You have to enable realtime capabilities in order to run MuSE."
	einfo "See http://www.gentoo.org/proj/en/desktop/sound/realtime.xml"
	einfo
	einfo "If using pam rlimits instead Realtime LSM and you hit this error:"
	einfo "\"RtcTimer::setTimerFreq(): cannot set tick on /dev/rtc: Permission
	denied\""
	einfo "add the following to /etc/conf.d/local.start"
	einfo "echo 1024 > /proc/sys/dev/rtc/max-user-freq"
	echo
}
