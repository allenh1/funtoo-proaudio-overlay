# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

[[ "${PV}" = "9999" ]] && inherit subversion
inherit autotools-utils

DESCRIPTION="An old-school all-digital drum-kit sampler synthesizer with stereo fx."
HOMEPAGE="http://drumkv1.sourceforge.net/"

if [[ "${PV}" = "9999" ]]; then
	ESVN_REPO_URI="http://svn.code.sf.net/p/${PN}/code/trunk"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

IUSE="alsa debug jack lv2"

LICENSE="GPL-2"

SLOT="0"

RDEPEND="dev-qt/qtcore
dev-qt/qtgui
media-libs/libsndfile
alsa? ( media-libs/alsa-lib )
jack? ( media-sound/jack-audio-connection-kit )
lv2? ( media-libs/lv2 )"
DEPEND="${RDEPEND}"

[[ "${PV}" = "9999" ]] && AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local myeconfargs=(
		$(use_enable alsa alsa-midi)
		$(use_enable debug)
		$(use_enable jack)
		$(use_enable lv2)
	)
	autotools-utils_src_configure
}
