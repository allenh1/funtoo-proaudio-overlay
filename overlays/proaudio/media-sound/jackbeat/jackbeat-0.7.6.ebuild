# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="An audio sequencer for Linux"
HOMEPAGE="http://www.samalyse.com/jackbeat/"
SRC_URI="http://www.samalyse.com/jackbeat/files/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry "${PN}" "Jackbeat" "/usr/share/${PN}/pixmaps/${PN}_logo.png" "AudioVideo"
	dodoc AUTHORS ChangeLog README NEWS
}
