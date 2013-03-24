# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

[[ "${PV}" = "9999" ]] && inherit subversion
inherit autotools-utils

DESCRIPTION="MIDI Arpeggiator w/ JACK Tempo Sync, includes Zonage MIDI splitter/manipulator"
HOMEPAGE="http://sourceforge.net/projects/${PN}"

RESTRICT="mirror"
if [[ "${PV}" = "9999" ]]; then
	ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.12:2.4
	dev-cpp/libxmlpp:2.6
	>=media-sound/jack-audio-connection-kit-0.105.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}/${PN}-doc.patch"
	"${FILESDIR}/${PN}-gcc46.patch"
	"${FILESDIR}/${PN}-gcc47.patch"
)

[[ "${PV}" = "9999" ]] && PATCHES+=( "${FILESDIR}/${P}-makefile-am.patch" )

AUTOTOOLS_AUTORECONF=1

src_install() {
	autotools-utils_src_install

	doicon "${S}/src/${PN}.png"
	doicon "${S}/src/zonage.png"
	make_desktop_entry "${PN}" Arpage "${PN}" "AudioVideo;Audio;Midi;X-Jack"
	make_desktop_entry "zonage" Zonage "zonage" "AudioVideo;Audio;Midi;X-Jack"
}
