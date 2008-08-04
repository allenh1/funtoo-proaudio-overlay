# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PN=pa_stable_v
MY_PV="$(get_version_component_range 1)_$(get_version_component_range 2)"
MY_P=${MY_PN}${MY_PV}

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
SRC_URI="http://portaudio.com/archives/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="19"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug oss jack"

DEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	econf $(use_with alsa)\
		$(use_with jack) \
		$(use_with oss)\
		$(use_enable debug debug-output)\
		--enable-cxx\
		|| die "econf failed"

	emake || die "emake failed"

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install faied"
	dodoc V19-devel-readme.txt
	dohtml index.html
}
