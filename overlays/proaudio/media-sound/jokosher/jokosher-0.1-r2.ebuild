# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# source http://bugs.gentoo.org/show_bug.cgi?id=141362

RESTRICT="nomirror"
inherit python eutils
DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org/"
SRC_URI="http://www.jokosher.org/downloads/source/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
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

# name of user executable python script
OLD_PYEXE="Jokosher.py"
NEW_PYEXE="${PN}"
# parent install path
IPATH="/usr/share/${PN}/"

src_install() {

	cd ${S}
	
	# install documentation
	dodoc AUTHORS README
	use doc && dohtml -r doc/*

	# install application
	insinto ${IPATH}
	doins -r images Instruments *.py *.glade *.png
	# make $OLD_PYEXE executable
	fperms 755 ${IPATH}${OLD_PYEXE}

	# install app icon
	doicon ${PN}.png
	# install app desktop entry
	domenu ${PN}.desktop

	# create ${NEW_PYEXE} wrapper
	make_wrapper ${NEW_PYEXE} ${IPATH}${OLD_PYEXE} \
	"\${PWD}" "" "/usr/bin/"
	
	# update .desktop to match wrapper
	dosed "s/${OLD_PYEXE}/${NEW_PYEXE}/" \
	/usr/share/applications/${PN}.desktop \
	|| die "Sed failed"

}

pkg_postinst() {

	# byte compile all python mods
	python_mod_optimize ${IPATH}

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
	python_mod_cleanup ${IPATH}

}
