# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="alsa jack lua"

inherit eutils qt3

S="${WORKDIR}/${PN}-1.5.0/src"

DESCRIPTION="Digital DJ tool using QT 3.x"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="mirror://sourceforge/mixxx/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND="$(qt_min_version 3.1)
	media-sound/madplay
	media-libs/libogg
	media-libs/libvorbis
	media-libs/audiofile
	media-libs/libsndfile
	media-libs/libsamplerate
	>=media-libs/portaudio-19
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	lua? ( dev-lang/lua )"

RDEPEND="${DEPEND}
	 dev-lang/perl"

DEPEND="${DEPEND}
	sys-apps/sed"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	# fix gcc4 errors (virtual destructor)
	sed -i -e "162,163s|SoundTouch::||" ../lib/soundtouch/SoundTouch.h || die
	sed -i -e "48,49s|Rhythmogram::||" wavesegmentation.h || die
	# fix cflags
	sed -i -e "s:\(QMAKE_CXXFLAGS\)\(.*\):\1 += ${CFLAGS} -pipe:" \
	     -e "s:\(QMAKE_CFLAGS\)\(.*\):\1 += ${CFLAGS} -pipe:" \
		 mixxx.pro || die "patching failed"
}

src_compile() {
	# econf won't work
	./configure `use_enable alsa` `use_enable jack` || die "configure failed"

	#sed -i -e "s/CFLAGS *= -pipe -w -O2/CFLAGS   = ${CFLAGS} -w/" \
	#       -e "s/CXXFLAGS *= -pipe -w -O2/CXXFLAGS   = ${CXXFLAGS} -w/" Makefile
	addpredict  ${QTDIR}/etc/settings
	emake || die "make failed"
}

src_install() {
	make COPY_FILE="cp -fpr" \
	     INSTALL_ROOT="${D}" install || die "make install failed"

	dodoc ../README ../README.ALSA ../Mixxx-Manual.pdf
	
	newicon "${S}/src/mixxx-icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Mixxx" "${PN}" "AudioVideo;Audio"
}
