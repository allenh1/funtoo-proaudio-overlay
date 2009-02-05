# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils flag-o-matic toolchain-funcs

MY_P=${P/museseq/muse}
MY_P=${MY_P/_/}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fluidsynth lash pch"

DEPEND=">=x11-libs/qt-3.2.0:3
	>=media-libs/alsa-lib-0.9.0
	fluidsynth? ( >=media-sound/fluidsynth-1.0.3 )
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.0
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash? ( >=media-sound/lash-0.5.0 )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# new strange --as-needed error, not like the old one
	filter-ldflags -Wl,--as-needed --as-needed

	econf \
		`use_enable lash` \
		`use_enable debug` \
		`use_enable pch` \
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

	newicon "packaging/muse_icon.png" "${PN}.png"
	make_desktop_entry ${PN} "MusE Sequencer" ${PN} "AudioVideo;Audio;Sequencer"
}

pkg_postinst() {
	echo
	einfo "You have to enable realtime capabilities in order to run MuSE."
	einfo "See http://www.gentoo.org/proj/en/desktop/sound/realtime.xml"
	einfo
	einfo "If using pam rlimits instead Realtime LSM and you hit this error:"
	einfo "\"RtcTimer::setTimerFreq(): cannot set tick on /dev/rtc: Permission denied\""
	einfo "add the following to /etc/sysctl.conf and run \"sysctl -a\""
	echo
	einfo "dev.rtc.max-user-freq = 1024"
	echo
}
