# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit autotools bzr

DESCRIPTION="Free software synthesizer inspired by the ideas of the Reactable"
HOMEPAGE="http://www.psychosynth.com/"
EBZR_REPO_URI="http://bzr.savannah.gnu.org/r/psychosynth/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa jack +psynth3d oss sndfile vorbis xml osc"

DEPEND="osc? ( >=media-libs/liblo-0.24 )
	>=media-libs/libsoundtouch-1.3.1-r1
	>=dev-libs/boost-1.35.0-r2
	>=dev-libs/libsigc++-2.2.3
	alsa? ( >=media-libs/alsa-lib-1.0.14a-r1 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.103.0 )
	psynth3d? ( >=dev-games/cegui-0.5.0b-r3
				>=dev-games/ois-1.2.0
				>=dev-games/ogre-1.4.9 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	vorbis? ( >=media-libs/libvorbis-1.2.0 )
	xml? ( >=dev-libs/libxml2-2.6.31 )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if use psynth3d; then
		if ! built_with_use dev-games/ogre cegui devil; then
			eerror "You need to compile dev-games/ogre with"
			eerror "USE=\"cegui devil\"!"
			die "Deps missing"
		fi
	fi
	if ! use alsa && ! use jack && ! use oss; then
		eerror "You need to enable either alsa, jack or oss USE flag, or"
		eerror "psychosynth will not compile"
		die "No audio system enabled"
	fi
}

src_unpack() {
	bzr_src_unpack
	cd "${S}"

	# stop install failing on ChangeLog?!
	sed -i -e '/noinst_DATA = ChangeLog/d' \
		"${S}/Makefile.am" || die "sed of Makefile.am failed"

	eautoreconf
}

src_compile() {
	econf  $(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable psynth3d) \
		$(use_enable sndfile) \
		$(use_enable vorbis) \
		$(use_enable xml libxml) \
		$(use_enable oss) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

