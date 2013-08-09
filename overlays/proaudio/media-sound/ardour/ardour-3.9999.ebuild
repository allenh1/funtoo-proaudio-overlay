# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils fdo-mime git-2 waf-utils

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

EGIT_REPO_URI="git://git.${PN}.org/${PN}/${PN}.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS=""
IUSE="altivec debug doc nls sse lv2 vst wiimote"

RDEPEND="dev-cpp/cairomm
	>=dev-cpp/gtkmm-2.8.0
	>=dev-cpp/glibmm-2.32.0
	>=dev-cpp/libgnomecanvasmm-2.20.0
	>=dev-libs/glib-2.2
	>=dev-libs/libsigc++-2.0
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	|| ( dev-libs/serd =media-sound/drobilla-9999 )
	gnome-base/libgnomecanvas
	>=media-libs/alsa-lib-1.0.14a-r1
	media-libs/aubio
	media-libs/flac
	media-libs/liblo
	>=media-libs/liblrdf-0.4.0
	>=media-libs/libsamplerate-0.1.1-r1
	>=media-libs/libsndfile-1.0.18_pre24
	media-libs/libsoundtouch
	>=media-libs/raptor-1.4.2[curl]
	|| ( >=media-libs/suil-0.6.2 =media-sound/drobilla-9999 )
	>=media-libs/taglib-1.5
	>=media-sound/jack-audio-connection-kit-0.120.1
	net-misc/curl
	=sci-libs/fftw-3*
	virtual/libusb
	>=x11-libs/gtk+-2.12.1
	x11-libs/pango
	x11-themes/gtk-engines
	lv2? ( || (
		>=media-libs/lilv-0.14.0
		=media-sound/drobilla-9999
	) )
	wiimote? ( app-misc/cwiid )"

DEPEND="${RDEPEND}
	dev-libs/boost
	>=dev-util/scons-0.98.5
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

src_unpack() {
	git-2_src_unpack
}

src_configure() {

	local myconf=(
		--freedesktop
		--noconfirm
		$(usex debug --debug "")
		$(usex nls --nls "")
		$(usex lv2 --lv2 --no-lv2)
		$(usex wiimote --wiimote "")
		$(usex vst --windows-vst "")
		$(usex doc --docs "")
	)

	if use sse || use altivec ;then
		myconf+=( --fpu-optimization )
	fi

	waf-utils_src_configure ${myconf[@]}
}

src_install() {
	waf-utils_src_install

	newicon "icons/icon/ardour_icon_tango_48px_red.png" "ardour3.png"
	make_desktop_entry "ardour3" "Ardour3" "ardour3" "AudioVideo;Audio"
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	ewarn "---------------- WARNING -------------------"
	ewarn ""
	ewarn "MAKE BACKUPS OF THE SESSION FILES BEFORE TRYING THIS VERSION."
	ewarn ""
	ewarn "The simplest way to address this is to make a copy of the session file itself"
	ewarn "(e.g mysession/mysession.ardour) and make that file unreadable using chmod(1)."
	ewarn ""
}
