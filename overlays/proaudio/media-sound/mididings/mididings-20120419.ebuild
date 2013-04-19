# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2} )
PYTHON_REQ_USE="tk?"
inherit distutils-r1

DESCRIPTION="A MIDI router and processor based on Python, supporting ALSA and JACK MIDI"
HOMEPAGE="http://das.nasophon.de/mididings/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus doc examples inotify jack osc smf tk"
REQUIRED_USE="|| ( alsa jack )"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/boost-1.34.1[python,threads,${PYTHON_USEDEP}]
	dev-libs/glib:2
	dev-python/decorator[${PYTHON_USEDEP}]
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	inotify? ( >=dev-python/pyinotify-0.8[${PYTHON_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.116.0 )
	smf? ( media-libs/libsmf )
	osc? ( >=media-libs/pyliblo-0.9.1-r1[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

PATCHES=( "${FILESDIR}"/${P}-boost_python.patch )

python_configure_all() {
	mydistutilsargs=(
		$(use_enable alsa alsa-seq)
		$(use_enable jack jack-midi)
		$(use_enable smf)
	)
}

python_install_all() {
	use doc && HTML_DOCS=( doc/ )
	use examples && EXAMPLES=( doc/examples/*.py )

	distutils-r1_python_install_all
}
