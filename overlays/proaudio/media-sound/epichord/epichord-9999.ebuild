# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit base flag-o-matic multilib git-r3

DESCRIPTION="a classical multi-track midi sequencer"
HOMEPAGE="http://repo.or.cz/w/epichord.git"

EGIT_REPO_URI="git://repo.or.cz/epichord.git"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/fltk:2
	>=media-sound/jack-audio-connection-kit-0.109.2"
DEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog NEWS docs/README TODO"

src_compile() {
	# work around #251233
	append-flags "-L/usr/$(get_libdir)/fltk"

	econf || die
	emake || die
}
