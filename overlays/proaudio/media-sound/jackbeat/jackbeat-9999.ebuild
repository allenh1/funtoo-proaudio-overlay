# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils subversion

DESCRIPTION="An audio sequencer for Linux"
HOMEPAGE="http://www.samalyse.com/jackbeat/"
ESVN_REPO_URI="http://svn.samalyse.com/${PN}/trunk"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="jack pulseaudio"

RDEPEND="media-libs/alsa-lib
	media-libs/liblo
	>=media-libs/portaudio-19
	>=x11-libs/gtk+-2.6
	>=media-libs/libsndfile-1.0.15
	>=dev-libs/libxml2-2.6
	>=media-libs/libsamplerate-0.1.2
	jack? ( media-sound/jack-audio-connection-kit )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}"

src_prepare() {
	eaclocal || die "eaclocal failed"
	eautoheader || die "eautoheader failed"
	eautomake || die "eautomake failed"
	eautoconf || die "eautoconf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry "${PN}" "Jackbeat" "/usr/share/${PN}/pixmaps/${PN}_logo.png" "AudioVideo"
	dodoc AUTHORS ChangeLog README NEWS
}
