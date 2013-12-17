# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/jackminimix/jackminimix-0.1.ebuild,v 1.1 2006/04/11 21:01:12 gimpel Exp $

EAPI="2"

inherit git-r3

DESCRIPTION="a simple mixer for the Jack Audio Connection Kit with an OSC based
control interface"
HOMEPAGE="http://www.aelius.com/njh/jackminimix/"
EGIT_REPO_URI="http://github.com/njh/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100
		>=media-libs/liblo-0.23"

DEPEND="${RDEPEND}"

src_configure(){
	"${S}/autogen.sh" || die
}

src_install(){
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS TODO ChangeLog
}
