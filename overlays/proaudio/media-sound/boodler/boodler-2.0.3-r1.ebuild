# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.4"

inherit distutils bash-completion

MY_P="Boodler-${PV}"

DESCRIPTION="Tool for creating soundscapes -- continuous, infinitely varying streams of sound"
HOMEPAGE="http://boodler.org/"
SRC_URI="http://boodler.org/dl/${MY_P}.tar.gz"
LICENSE="LGPL-2 GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa bash-completion coreaudio doc esd intmath jack lame pulseaudio qt4 shout vorbis"

RESTRICT="mirror"

DEPEND="alsa? ( >=media-libs/alsa-lib-1.0.17a )
	esd? ( >=media-sound/esound-0.2.41 )
	jack? ( >=media-libs/bio2jack-0.9 )
	lame? ( >=media-sound/lame-3.98.2-r1 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	shout? ( >=media-libs/libshout-2.1 )
	vorbis? ( >=media-libs/libvorbis-1.2.1_rc1-r2 )"
RDEPEND="${DEPEND}
	qt4? ( >=dev-python/PyQt4-4.7.3[X] )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use shout && ! use vorbis ; then
		eerror "To have shout support, you also need to build boodler with"
		eerror "USE=\"vorbis\"!"
		die
	fi
}

src_prepare() {
	local defdriver
	local with
	local without

	# set up a default audio driver (not daemon) according to USE flags.
	# it does not appear to work in setup.cfg so there is a workaround below.
	if use coreaudio ; then
		defdriver=macosx
	elif use alsa ; then
		defdriver=alsa
	else
		defdriver=oss
	fi

	# this ugly code enables/disables the output drivers
	# oss seems to be needed for boodler.py --list-drivers to work
	with="${with}oss,"
	use alsa && with="${with}alsa," || without="${without}alsa,"
	use coreaudio && with="${with}macosx,osxaq," \
		|| without="${without}macosx,osxaq,"
	use esd && with="${with}esd," || without="${without}esd,"
	use jack && with="${with}jackb," || without="${without}jackb,"
	use lame && with="${with}lame," || without="${without}lame,"
	use pulseaudio && with="${with}pulse," || without="${without}pulse,"
	use shout && with="${with}shout," || without="${without}shout,"
	use vorbis && with="${with}vorbis," || without="${without}vorbis,"

	# move the original setup.cfg out of the way as a backup to check syntax
	mv "${S}/setup.cfg" "${T}/setup.cfg.original" || die "setup.cfg not found"

	# fill the setup.cfg with the values
	cat > "${S}/setup.cfg" <<-EOF
		[build_scripts]
		default_driver=${defdriver}
		[build_ext]
		with-drivers=${with}
		without-drivers=${without}
		intmath=$(use intmath && echo 1 || echo 0)
	EOF

	# workaround for default-driver in setup.cfg not functioning
	$(PYTHON) setup.py build_scripts \
		--default-driver ${defdriver} \
		|| die "$(PYTHON) setup.py build_scripts failed"

	# fix boodle-ui-qt.py shebang
	if use qt4 ; then
		cp "${FILESDIR}/boodle-ui-qt.py" "${T}/boodle-ui-qt.py" \
			|| die "cp ${FILESDIR}/boodle-ui-qt.py ${T}/boodle-ui-qt.py failed"
		python_convert_shebangs $(python_get_version) "${T}/boodle-ui-qt.py"
	fi
}

src_install() {
	distutils_src_install

	# a bash completion addon script downloaded from the official site
	# http://boodler.org/dl/etc/bash_completion.d/boodler
	dobashcompletion "${FILESDIR}/boodler"

	# a pyqt4 gui addon for boodler downloaded from the official site
	# http://boodler.org/dl/etc/boodle-ui-qt.py
	if use qt4 ; then
		dobin "${T}/boodle-ui-qt.py" || die "boodle-ui-qt.py not found"
	fi

	# docs, better include them as boodler is not the most intuitive to use for
	# new users
	if use doc ; then
		pushd doc || die "doc dir not found"
		dohtml -r *
		popd
	fi
}
