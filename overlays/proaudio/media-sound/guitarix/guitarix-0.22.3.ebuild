# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit base eutils fdo-mime waf-utils

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
SRC_URI="mirror://sourceforge/guitarix/guitarix/${PN}2-${PV}.tar.bz2"
HOMEPAGE="http://guitarix.sourceforge.net/"

RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

IUSE="faust +meterbridge"

S="${WORKDIR}/guitarix-${PVR}"

DOCS=( "${S}/README" "${S}/changelog" )
PATCHES=( "${FILESDIR}/guitarix2-0.22.3-no-update-desktop-database.patch" )

RDEPEND="
	>=dev-libs/boost-1.42
	media-libs/ladspa-sdk
	>=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-1.9.2
	>=x11-libs/gtk+-2.20.0
	>=media-libs/zita-convolver-3.0
	>=media-libs/zita-resampler-1.0
	faust? ( dev-lang/faust )
	>=sci-libs/fftw-3.1.2
	>=dev-cpp/gtkmm-2.24
	meterbridge? ( media-sound/meterbridge )
	!media-sound/guitarix"
#	media-sound/lame
#	media-sound/vorbis-tools
#	capture? ( media-sound/jack_capture )

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	# Taken from waf-utils.eclass
        debug-print-function ${FUNCNAME} "$@"

        # @ECLASS-VARIABLE: WAF_BINARY
        # @DESCRIPTION:
        # Eclass can use different waf executable. Usually it is located in "${S}/waf".
        : ${WAF_BINARY:="${S}/waf"}

        tc-export AR CC CPP CXX RANLIB
	# Removed --libdir option (see bug #412133)
#        echo "CCFLAGS=\"${CFLAGS}\" LINKFLAGS=\"${LDFLAGS}\" \"${WAF_BINARY}\" --prefix=${EPREFIX}/usr $@ configure"
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" "${WAF_BINARY}" \
                "--prefix=${EPREFIX}/usr" \
                "$@" \
                configure || die "configure failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
