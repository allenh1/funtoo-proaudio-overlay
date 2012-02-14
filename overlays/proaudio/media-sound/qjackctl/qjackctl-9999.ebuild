# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4 subversion

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sourceforge.net/"

ESVN_REPO_URI="https://qjackctl.svn.sourceforge.net/svnroot/${PN}/trunk"
#ESVN_PROJECT="qjackctl-svn"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="alsa debug dbus jackmidi portaudio"

DEPEND="alsa? ( media-libs/alsa-lib )
	|| ( (
			x11-libs/qt-core:4
			x11-libs/qt-gui:4
		) >=x11-libs/qt-4.1:4 )
	dbus? ( x11-libs/qt-dbus )
	portaudio? ( media-libs/portaudio )
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${PN}"

src_compile() {
	make -f Makefile.svn || die
	econf \
		$(use_enable jackmidi jack-midi) \
		$(use_enable alsa alsa-seq) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable portaudio) \
		|| die "econf failed"

	# Emulate what the Makefile does, so that we can get the correct
	# compiler used.
	eqmake4 ${PN}.pro -o ${PN}.mak || die "eqmake4 failed"

	emake -f ${PN}.mak || die "emake failed"
}

src_install() {
	make -j1 DESTDIR="${D}" install || die "make install failed"

	rm "${D}/usr/share/applications/qjackctl.desktop"

	# Upstream desktop file is invalid, better stick with our for now.
	make_desktop_entry "${PN}" "QjackCtl" "${PN}"

	dodoc README ChangeLog TODO AUTHORS
}
