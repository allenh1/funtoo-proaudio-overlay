# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs fdo-mime flag-o-matic subversion versionator

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/3.0"


LICENSE="GPL-2"
SLOT="3"
KEYWORDS=""
IUSE="altivec debug freesound nls sse lv2 vst sys-libs"

RDEPEND="media-libs/liblo
	>=media-libs/taglib-1.5
	media-libs/aubio
	>=media-libs/liblrdf-0.4.0
	>=media-libs/raptor-1.4.2
	>=media-sound/jack-audio-connection-kit-0.116.2
	>=dev-libs/glib-2.10.3
	x11-libs/pango
	>=x11-libs/gtk+-2.8.8
	media-libs/flac
	>=media-libs/alsa-lib-1.0.14a-r1
	>=media-libs/libsamplerate-0.1.1-r1
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	>=media-libs/libsndfile-1.0.18_pre24
	gnome-base/libgnomecanvas
	x11-themes/gtk-engines
	>=dev-cpp/gtkmm-2.12.3
	>=dev-cpp/glibmm-2.14.2
	>=dev-cpp/libgnomecanvasmm-2.20.0
	dev-cpp/cairomm
	>=dev-libs/libsigc++-2.0
	media-libs/libsoundtouch
	dev-libs/libusb
	=sci-libs/fftw-3*
	freesound? ( net-misc/curl )
	lv2? ( >=media-libs/slv2-0.6.1 )"

DEPEND="${RDEPEND}
	sys-devel/libtool
	dev-libs/boost
	dev-util/pkgconfig
	>=dev-util/scons-0.98.5
	nls? ( sys-devel/gettext )"

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	# some temporary slotting fixes
	sed -i -e 's:ardour2:ardour3:' \
		libs/rubberband/SConscript \
		libs/clearlooks-older/SConscript \
		|| die
		# now it gets dirty... the locale files...
	sed -e "s:share/locale:share/ardour3/locale:" \
		-i SConstruct gtk2_ardour/SConscript || die
	sed -e "s:'share', 'locale':'share', 'ardour3', 'locale':" \
		-i libs/ardour/SConscript
}
	
src_compile() {
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	local myconf=""
	(use sse || use altivec) && myconf="FPU_OPTIMIZATION=1"
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?"
	! use vst; myconf="${myconf} VST=$?"
	! use sys-libs; myconf="${myconf} SYSLIBS=$?"
	! use sse; myconf="${myconf} USE_SSE_EVERYWHERE=$? BUILD_SSE_OPTIMIZATIONS=$?"
	! use lv2; myconf="${myconf} LV2=$?"

	# static settings
	myconf="${myconf} DESTDIR=${D} PREFIX=/usr KSI=0"
	einfo "${myconf}"

	cd ${S}
	scons ${myconf}	${MAKEOPTS} || die "compilation failed"
}

src_install() {
	scons install || die "make install failed"
	if use vst;then
		mv "${D}"/usr/bin/ardourvst "${D}"/usr/bin/ardour2
	fi

	dodoc DOCUMENTATION/*

	newicon "icons/icon/ardour_icon_tango_48px_blue.png" "ardour3.png"
	make_desktop_entry "ardour3" "Ardour3" "ardour3" "AudioVideo;Audio"

	# fix wrapper
	sed -i -e 's:ardour2:ardour3:g' ${D}/usr/bin/ardour3 || die
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
