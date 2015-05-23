# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
inherit python eutils subversion
DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org/"
ESVN_REPO_URI="http://svn.jokosher.python-hosting.com/JonoEdit/trunk"

KEYWORDS=""
SLOT="0"
LICENSE="GPL-2"
IUSE="doc mad ladspa"

# gstreamer deps
GSTDEPEND=">=media-libs/gstreamer-0.10.12
	>=media-libs/gst-plugins-good-0.10.5
	>=media-plugins/gst-plugins-alsa-0.10.12
	media-plugins/gst-plugins-vorbis
	media-plugins/gst-plugins-ogg
	media-plugins/gst-plugins-flac
	>=media-plugins/gst-plugins-lame-0.10.4
	media-plugins/gst-plugins-gnomevfs
	>=media-libs/gnonlin-0.10.8
	mad? ( >=media-libs/gst-plugins-ugly-0.10.4 )
	ladspa? ( >=media-libs/gst-plugins-bad-0.10.4 )"

# python deps
PYDEPEND=">=dev-lang/python-2.4
	dev-python/pygtk
	>=dev-python/gst-python-0.10.6
	>=dev-python/pyxml-0.8.4
	>=dev-python/pycairo-1.2.0
	>=dev-python/dbus-python-0.71
	>=dev-python/setuptools-0.6_rc6
	dev-python/gnome-python"

# misc deps
RDEPEND="${GSTDEPEND}
	${PYDEPEND}
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

	newicon "images/${PN}-icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Jokosher" "${PN}" "AudioVideo;AudioVideoEditing;"
}

pkg_postinst() {

	# byte compile all python mods
	python_mod_optimize /usr/share/${PN}

}

pkg_postrm() {

	# remove orphaned *.py[co]
	python_mod_cleanup /usr/share/${PN}

}
