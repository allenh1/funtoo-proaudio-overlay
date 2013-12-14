# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils python-single-r1

DESCRIPTION="capture audio/video of the screen via FFmpeg with GUI"
HOMEPAGE="https://launchpad.net/~hizo/+archive/screencastor"
SRC_URI="http://hizo.fr/linux/${PN}/${PN}_${PV}.tar.gz"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="jack"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygtksourceview[${PYTHON_USEDEP}]
	media-gfx/imagemagick
	x11-apps/xwininfo
	x11-libs/vte:0[python,${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	virtual/ffmpeg
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
	python_scriptinto "/usr/share/${PN}/"
	python_doscript "${PN}.py"
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
