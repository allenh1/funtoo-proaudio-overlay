# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools
RESTRICT="nomirror"
DESCRIPTION="Free software synthesizer inspired by the ideas of the Reactable"
HOMEPAGE="http://www.psychosynth.com/"
SRC_URI="http://forja.rediris.es/frs/download.php/707/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa jack psynth3d oss sndfile vorbis xml osc"

DEPEND="osc? ( >=media-libs/liblo-0.24 )
	>=media-libs/libsoundtouch-1.3.1-r1
	alsa? ( >=media-libs/alsa-lib-1.0.14a-r1 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )
	psynth3d? ( >=dev-games/cegui-0.5.0b-r3
				>=dev-games/ois-1.2.0
				>=dev-games/ogre-1.4.7 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	vorbis? ( >=media-libs/libvorbis-1.2.0 )
	xml? ( >=dev-libs/libxml2-2.6.31 )"


pkg_setup() {
	if use psynth3d; then
		if ! built_with_use dev-games/ogre cegui devil; then
			eerror "You need to compile dev-games/ogre with"
			eerror "USE=\"cegui devil\"!"
			die "Deps missing"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	# fix up soundtouch checks in configure.ac
	sed -i -e "s/\[\ libSoundTouch\ \]/\[\ soundtouch-1.0\ \]/"	\
		"${S}/configure.ac" || die "sed of configure.ac failed"
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf  $(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable psynth3d) \
		$(use_enable sndfile) \
		$(use_enable vorbis) \
		$(use_enable xml) \
		$(use_enable oss) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

