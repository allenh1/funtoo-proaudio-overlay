# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="capture audio/video of the screen via FFmpeg with GUI"
HOMEPAGE="https://launchpad.net/~hizo/+archive/${PN}"
SRC_URI="http://hizo.fr/linux/${PN}/${PN}_${PV}.tar.gz"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="jack"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk
	x11-libs/vte
	x11-misc/xdg-utils
	media-gfx/imagemagick
	x11-apps/xwininfo
	virtual/ffmpeg
	dev-python/pygtksourceview
	jack? ( media-sound/jack-audio-connection-kit )"
	# portage ebuild doesn't have the python bilding => no tray icon
	# dev-libs/libappindicator"

S="${WORKDIR}/${PN}_test"

src_prepare() {
	# fix python shebang and gettext calls
	epatch \
		"${FILESDIR}"/${P}_python+gettext.patch
	# add jack support
	if use jack ; then
		epatch "${FILESDIR}"/${P}_jack.patch
	fi
}

src_install() {
	mkdir -p "${D}/usr/share/${PN}" || die "mkdir failed"
	cp -r * "${D}/usr/share/${PN}" || die "install common files failed"
	python_replicate_script \
		"${D}/usr/share/${PN}/${PN}".py
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}"

	make_desktop_entry "${PN}" ScreenCastor /usr/share/"${PN}/${PN}".png AudioVideo
}

pkg_postinst() {
	einfo ""
	einfo "To make a screen cast with ScreenCastor,"
	einfo "don't forget to set the output file."
	einfo ""
	einfo "To use JACK, select jack as sound server"
	einfo "and screencastorjack as source."
	einfo ""
}
