# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit qt4-r2 git-2

EGIT_REPO_URI="git://git.code.sf.net/p/faudiostream/faustworks"

DESCRIPTION="IDE for the Faust dsp programming language"
HOMEPAGE="http://www.fauste.grame.fr/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/${PN}"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtxmlpatterns:4
	dev-qt/qtsvg:4"
RDEPEND="${DEPEND}
	dev-lang/faust"

src_install() {
	dobin FaustWorks
	dodoc README
	insinto "/usr/share/FaustWorks/Forms"
	doins Forms/*
	insinto "/usr/share/FaustWorks/Resources"
	doins Resources/*
	insinto "/usr/share/pixmaps"
	doins Resources/faustworks.xpm
	insinto "/usr/share/applications"
	doins faustworks.desktop
}

pkg_postinst() {
	einfo "FaustWorks can be used for the following types of Faust projects:"
	einfo "alsa-gtk, alsa-qt, csound, dssi, jack-gtk, jack-qt, ladspa, puredata and supercollider."
	einfo ""
	einfo "You may want to install some of those software."
}
