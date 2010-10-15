# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.4"

inherit python distutils bash-completion

MY_P="Boodler-${PV}"

DESCRIPTION="Tool for creating soundscapes -- continuous, infinitely varying streams of sound"
HOMEPAGE="http://boodler.org/"
SRC_URI="http://boodler.org/dl/${MY_P}.tar.gz"
LICENSE="GPL-2 LGPL-2 public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa bash-completion esd intmath jack lame pulseaudio shout vorbis"
RESTRICT="mirror"

DEPEND="alsa? ( >=media-libs/alsa-lib-1.0.17a )
		esd? ( >=media-sound/esound-0.2.41 )
		jack? ( >=media-libs/bio2jack-0.9 )
		lame? ( >=media-sound/lame-3.98.2-r1 )
		pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
		shout? ( >=media-libs/libshout-2.1 )
		vorbis? ( >=media-libs/libvorbis-1.2.1_rc1-r2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use shout && ! use vorbis; then
		eerror "To have shout support, you also need to build boodler with"
		eerror "USE=\"vorbis\"!"
		die
	fi
}

src_prepare() {
	local default_driver
	local with
	local without
	use alsa && default_driver=alsa || default_driver=oss
	use alsa && with="${with}alsa," || without="${without}alsa,"
	use esd && with="${with}esd," || without="${without}esd,"
	use jack && with="${with}jackb," || without="${without}jackb,"
	use lame && with="${with}lame," || without="${without}lame,"
	use pulseaudio && with="${with}pulse," || without="${without}pulse,"
	use shout && with="${with}shout," || without="${without}shout,"
	use vorbis && with="${with}vorbis," || without="${without}vorbis,"
	cat > "${S}/setup.cfg" <<-EOF
		[build_scripts]
		default_driver=${default_driver}
		[build_ext]
		with-drivers=${with}
		without-drivers=${without}
		intmath=$(use intmath && echo 1 || echo 0)
	EOF
}

src_install() {
	distutils_src_install

	# a bash completion addon script downloaded from the official site
	dobashcompletion "${FILESDIR}/boodler"
}
