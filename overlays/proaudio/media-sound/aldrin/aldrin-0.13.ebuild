# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

DESCRIPTION="Aldrin is an open source modular sequencer/tracker, compatible to
Buzz"
HOMEPAGE="http://code.google.com/p/aldrin-sequencer/"
SRC_URI="http://aldrin-sequencer.googlecode.com/files/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=media-libs/armstrong-0.2.6"
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
