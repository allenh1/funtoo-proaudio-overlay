# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
inherit python eutils subversion
DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org/"
SRC_URI=""
ESVN_REPO_URI="http://svn.jokosher.python-hosting.com/JonoEdit/trunk"

KEYWORDS="-*"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc"

# gstreamer deps
# gst-plugins-alsa-0.10.9 is essential for Jokosher to function correctly
GSTDEPEND=">=media-libs/gstreamer-0.10.9
	media-libs/gst-plugins-good
	>=media-plugins/gst-plugins-alsa-0.10.9
	media-plugins/gst-plugins-vorbis
	media-plugins/gst-plugins-ogg
	media-plugins/gst-plugins-flac
	>=media-plugins/gst-plugins-lame-0.10.3
	media-plugins/gst-plugins-gnomevfs
	=media-libs/gnonlin-0.10.5"

# python deps
# pyalsaaudio b.g.o 114526 NOT 141915
# NOTE: pyalsaaudio is no longer required in svn
# and should be removed upon a subsequent release
PYDEPEND=">=dev-lang/python-2.4
	dev-python/pygtk
	>=dev-python/pyalsaaudio-0.2
	dev-python/gst-python
	dev-python/pyxml
	dev-python/pycairo"

# misc deps
RDEPEND="${GSTDEPEND}
	${PYDEPEND}
	>=dev-python/dbus-python-0.71
	gnome-base/librsvg
	x11-themes/hicolor-icon-theme"

src_install() {

	# install documentation
	dodoc AUTHORS README
	use doc && dohtml -r doc/*

	# install application
	insinto /usr/share/${PN} 
	doins -r images Instruments Jokosher
	fperms 755 /usr/share/${PN}/Jokosher/JokosherApp.py
	dosym /usr/share/${PN}/Jokosher/JokosherApp.py /usr/bin/jokosher
	
	newicon "images/${PN}-logo.png" "${PN}.png"
	make_desktop_entry "${PN}" "Jokosher" "${PN}" "AudioVideo;AudioVideoEditing;"
}

pkg_postinst() {

	# byte compile all python mods
	python_mod_optimize /usr/share/${PN} 

	echo
	ewarn "The Jokosher developers currently recommend that CVS GStreamer is used in"
	ewarn "conjunction with this release."
	ewarn "It is therefore *HIGHLY* likely that you will encounter problems when"
	ewarn "using versions of GStreamer from Portage."
	ewarn "If this is the case then you are urged to follow the instructions at"
	ewarn "http://www.jokosher.org/setting-up-cvs-gstreamer for details on installing"
	ewarn "CVS GStreamer in parallel to your current version(s)."
	echo

}

pkg_postrm() {

	# remove orphaned *.py[co]
	python_mod_cleanup /usr/share/${PN} 

}
