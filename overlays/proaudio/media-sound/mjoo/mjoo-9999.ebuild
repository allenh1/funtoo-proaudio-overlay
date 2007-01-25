# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/mjoo/mjoo-9999.ebuild,v 1.1 2006/04/10 18:08:30 gimpel Exp $

inherit subversion virtualx2

DESCRIPTION="mjoo is a live sequencer with ZUI interface using jack"
HOMEPAGE="http://mjoo.org"

ESVN_REPO_URI="http://svn.zeitherrschaft.org/mjoo/trunk"
S="${WORKDIR}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dssi ladspa"

DEPEND="${RDEPEND}
		>=media-sound/jack-audio-connection-kit-0.100
		>=x11-libs/gtk+-2.8
		dev-python/twisted
		dev-python/pygtk
		dev-python/pyopengl
		>=dev-python/ctypes-0.9.6
		dev-python/pygtkglext
		dssi? ( media-libs/dssi )
		ladspa? ( >=media-libs/ladspa-sdk-1.12 )"
RDEPEND=">=dev-lang/python-2.4
		virtual/opengl"

pkg_setup() {
		# ugly temporary hack to make SConstruct happy
		mkdir -p /opt/mjoo
}

src_compile() {
		Xemake || die "make failed"
}

src_install() {
		# now lets cause a funky sandbox violation
		# make DESTDIR=${D}/opt/mjoo install || die "installation failed"
		# any idea on this one ^^?
		# dosym /opt/mjoo/mjoo /usr/bin/mjoo  # also fails

		# the above sucks, so lets install things manually
		insinto /opt/${PN}
		doins *.py *.glade *.so ${PN}
		fperms 755 /opt/mjoo/mjoo
}

pkg_postinst() {
	einfo ""
	einfo "You can now start mjoo with the command:"
	einfo ""
	einfo "/opt/mjoo/mjoo"
	einfo ""
}
