# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

[[ "${PV}" = "9999" ]] && inherit subversion

[[ "${PV}" = "9999" ]] && AUTOTOOLS_AUTORECONF="1"
inherit base qt4-r2 autotools-utils

DESCRIPTION="An old-school all-digital polyphonic sampler synthesizer with stereo fx."
HOMEPAGE="http://samplv1.sourceforge.net/"

RESTRICT="mirror"

if [[ "${PV}" = "9999" ]]; then
	ESVN_REPO_URI="http://svn.code.sf.net/p/${PN}/code/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

IUSE="alsa debug jack jackmidi jacksession lv2 nsm osc"
REQUIRED_USE="
	|| ( jack lv2 )
	jack? ( || ( alsa jackmidi ) )
	jackmidi? ( jack )
	jacksession? ( jack )"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-qt/qtcore
	dev-qt/qtgui
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD="1"

src_unpack() {
	[[ "${PV}" = "9999" ]] && subversion_src_unpack
	[[ "${PV}" = "9999" ]] || base_src_unpack
}

src_configure() {
	use jack && eqmake4 "${PN}_jack.pro" -o "${PN}_jack.mak"
	use lv2 && eqmake4 "${PN}_lv2.pro" -o "${PN}_lv2.mak"

	local myeconfargs=(
		$(use_enable alsa alsa-midi)
		$(use_enable debug)
		$(use_enable jack)
		$(use_enable jackmidi jack-midi)
		$(use_enable jacksession jack-session)
		$(use_enable lv2)
		$(use_enable osc liblo)
		$(use_enable nsm)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install INSTALL_ROOT="${D}"
}
