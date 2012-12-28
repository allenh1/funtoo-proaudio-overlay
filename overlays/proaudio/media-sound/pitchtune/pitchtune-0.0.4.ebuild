# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools-utils

DESCRIPTION="A GPL'ed GTK oscilloscope-style musical instrument tuning program."
HOMEPAGE="http://pitchtune.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DOCS=( AUTHORS ChangeLog README TODO )

DEPEND="=x11-libs/gtk+-2*
		>=media-libs/alsa-lib-0.9"
RDEPEND="${DEPEND}"

MY_PN="PitchTune"

src_install() {
	autotools-utils_src_install
	doicon "pixmaps/${PN}.xpm"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}" "AudioVideo;Audio;Tuner;"
}
