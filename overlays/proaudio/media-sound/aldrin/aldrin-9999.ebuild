# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial exteutils

DESCRIPTION="Aldrin is an open source modular sequencer/tracker, compatible to
Buzz"
HOMEPAGE="http://code.google.com/p/aldrin-sequencer/"
SRC_URI=""
EHG_REPO_URI="http://bitbucket.org/paniq/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="=media-libs/armstrong-9999"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${PN}

src_install() {
	escons PREFIX=/usr DESTDIR="${D}" install || die "install failed"
	dodoc CREDITS ChangeLog
	# fix FDO entry
	sed -i -e "s:AudioVideo;:AudioVideo;Audio;Sequencer;:" \
		"${D}/usr/share/applications/${PN}.desktop" \
		|| die "sed of ${PN}.desktop failed"
}
