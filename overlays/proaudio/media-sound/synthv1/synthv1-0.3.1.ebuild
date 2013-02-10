# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

[[ "${PV}" = "9999" ]] && inherit subversion
inherit autotools-utils

DESCRIPTION="An old-school all-digital 4-oscillator subtractive polyphonic synthesizer with stereo fx."
HOMEPAGE="http://synthv1.sourceforge.net/synthv1-index.html"

if [[ "${PV}" = "9999" ]]; then
	ESVN_REPO_URI="http://svn.code.sf.net/p/synthv1/code/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

IUSE="alsa debug jack lv2"

LICENSE="GPL-2"

SLOT="0"

RDEPEND="x11-libs/qt-core
x11-libs/qt-gui
alsa? ( media-libs/alsa-lib )
jack? ( media-sound/jack-audio-connection-kit )
lv2? ( media-libs/lv2 )"
DEPEND="${RDEPEND}"

[[ "${PV}" = "9999" ]] && AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local myeconfargs=(
		$(use_with alsa)
		$(use_with jack)
		$(use_with lv2)
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
