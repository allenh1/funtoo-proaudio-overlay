# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.9.ebuild,v 1.4 2008/07/27 21:30:21 carlo Exp $

EAPI="2"

inherit exteutils subversion

DESCRIPTION="MusE is a MIDI/Audio sequencer with recording and editing capabilities"
HOMEPAGE="http://www.muse-sequencer.org"
SRC_URI=""

ESVN_REPO_URI="https://lmuse.svn.sourceforge.net/svnroot/lmuse/trunk/muse"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc lash debug"

MY_PN=${PN/museseq/muse}

RDEPEND="
	x11-libs/qt-core:4[qt3support]
	x11-libs/qt-gui:4[qt3support]
	>=media-libs/alsa-lib-0.9.0
	>=media-sound/fluidsynth-1.0.3
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash? ( >=media-sound/lash-0.5.0 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-text/openjade
		app-doc/doxygen
		media-gfx/graphviz )"

S="${WORKDIR}/${MY_PN}"

src_configure() {
	einfo "Running autogen..."
	./autogen.sh || die "autogen failed"

	econf --disable-suid-build --disable-optimize \
		$(use_enable lash) $(use_enable debug) \
		|| die "econf failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README* SECURITY
	mv "${D}"/usr/bin/muse "${D}"/usr/bin/museseq
}

pkg_postinst() {
	elog "You must have the realtime module loaded to use MuSe.."
	elog "Additionally, configure your Linux Kernel for non-generic"
	elog "Real Time Clock support enabled or loaded as a module."
	elog "User must have read/write access to /dev/misc/rtc device."
	elog "Realtime LSM: http://www.gentoo.org/proj/en/desktop/sound/realtime.xml"
	echo
	elog "If using pam rlimits instead Realtime LSM and you hit this error:"
	elog "\"RtcTimer::setTimerFreq(): cannot set tick on /dev/rtc: Permission denied\""
	elog "add the following to /etc/conf.d/local.start"
	elog "echo 1024 > /proc/sys/dev/rtc/max-user-freq"
	elog "if /proc/sys/dev/rtc/max-user-freq could not be found"
	elog "you hav to load the rtc module: modprobe rtc"
	echo
}
