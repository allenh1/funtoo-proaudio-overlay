# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion toolchain-funcs

RESTRICT="mirror"
IUSE="alsa debug doc gir gtk lash qt4"
DESCRIPTION="Patchage is a modular patchbay for Jack audio and Alsa sequencer."
HOMEPAGE="http://drobilla.net/software/patchage"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND="!media-libs/raul
	!x11-libs/flowcanvas
	!dev-libs/serd
	!dev-libs/sord
	!media-libs/suil
	!media-libs/sratom
	!media-libs/lilv
	!media-plugins/mda-lv2
	!media-sound/ingen
	!media-sound/jalv
	!media-plugins/omins
	!media-sound/patchage
	>=dev-cpp/gtkmm-2.14.0:2.4
	>=dev-cpp/glibmm-2.14:2
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/libgnomecanvasmm-2.6
	dev-libs/boost
	>=net-libs/webkit-gtk-1.4.0
	dev-libs/boost
	dev-libs/libpcre
	>=media-libs/lv2-1.0.15
	>=media-sound/jack-audio-connection-kit-0.109.0
	alsa? ( media-libs/alsa-lib )
	gtk? ( >=x11-libs/gtk+-2.22.1-r1:2 )
	lash? ( dev-libs/dbus-glib )
	qt4? ( >=x11-libs/qt-core-4.0
		>=x11-libs/qt-gui-4.0 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-lang/python
	doc? ( app-doc/doxygen )"

pkg_setup() {
ewarn "${P} will install everything from http://drobilla.net/software"
ewarn "This mean that ${P} will install dev-libs/serd dev-libs/sord media-libs/lilv media-libs/raul media-libs/ratom meida-libs/suil media-sound/ingen media-sound/jalv media-sound/omins media-sound/patchage x11-libs/flowcanvas"
ewarn ""
ewarn "To install ${P}. you must uninstall the above softwares before to process."

# Fail with dbus
#	if use dbus && ! built_with_use media-sound/jack-audio-connection-kit dbus; then
#		eerror "You must install jack-audio-connection-kit with USE=dbus to have it in ${PN}"
#		die "Enabling dbus into ${PN} require it into media-sound/jack-audio-connection-kit"
#	fi
}

src_configure() {
	tc-export CC CXX CPP AR RANLIB
	./waf configure \
		--prefix=/usr \
		$(use debug && echo "--debug") \
		$(use alsa || echo "--no-alsa") \
		$(use gir && echo "--gir") \
		$(use lash || echo "--no-lash") \
		$(use doc && echo "--docs --docdir=/usr/share/doc/${P}/html") \
		|| die
}

src_compile() {
	./waf || die
}

src_install() {
	# addpredict for the ldconfig
#	addpredict /etc/ld.so.cache
	./waf install --destdir="${D}" || die
	dodoc README || die
	newdoc eugene/README README.eugene || die
	newdoc ganv/README README.ganv || die
	newdoc ganv/NEWS NEWS.ganv || die
	newdoc ganv/AUTHORS AUTHORS || die
	newdoc ingen/README README.ingen || die
	newdoc ingen/THANKS THANKS.ingen || die
	newdoc jalv/AUTHORS AUTHORS.jalv || die
	newdoc jalv/NEWS NEWS.jalv || die
	newdoc jalv/README README.jalv || die
	newdoc lilv/AUTHORS AUTHORS.lilv || die
	newdoc lilv/NEWS NEWS.lilv || die
	newdoc lilv/README README.lilv || die
	newdoc machina/README README.machina || die
	newdoc machina/THANKS THANKS.machina || die
	newdoc patchage/AUTHORS AUTHORS.patchage || die
	newdoc patchage/NEWS NEWS.patchage || die
	newdoc patchage/README README.patchage || die
	newdoc plugins/blop.lv2/AUTHORS AUTHORS.plugins_blop_lv2 || die
	newdoc plugins/blop.lv2/README README.plugins_blop_lv2 || die
	newdoc plugins/fomp.lv2/AUTHORS AUTHORS.plugins_fomp_lv2 || die
	newdoc plugins/fomp.lv2/NEWS NEWS.plugins_fomp_lv2 || die
	newdoc plugins/fomp.lv2/README README.plugins_blop_lv2 || die
	newdoc plugins/mda.lv2/README README.plugins_mda_lv2 || die
	newdoc plugins/omins.lv2/AUTHORS AUTHORS.plugins_omins_lv2 || die
	newdoc plugins/omins.lv2/NEWS NEWS.plugins_omins_lv2 || die
	newdoc plugins/omins.lv2/README README.plugins_omins_lv2 || die
	newdoc raul/NEWS NEWS.raul || die
	newdoc raul/README README.raul || die
	newdoc serd/NEWS NEWS.serd || die
	newdoc serd/README README.serd || die
	newdoc sord/NEWS NEWS.sord || die
	newdoc sord/README README.sord || die
	newdoc sratom/NEWS NEWS.sratom || die
	newdoc sratom/README README.sratom || die
	newdoc suil/NEWS NEWS.suil || die
}
