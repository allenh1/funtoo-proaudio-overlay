# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils base git-2 toolchain-funcs

RESTRICT="mirror"

DESCRIPTION="a pattern-based MIDI sequencer."
HOMEPAGE="http://${PN}.nongnu.org"

EGIT_REPO_URI="git://git.sv.gnu.org/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE=""

RDEPEND=">=dev-cpp/libglademm-2.4.1
	>=dev-cpp/libxmlpp-2.6.1
	media-sound/jack-audio-connection-kit
	virtual/liblash"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-no-override.patch"
)

display_warning() {
	ewarn "Emergeing ${P} will not build ${PN} itself. It will just"
	ewarn "install a library and some documentation."
	ewarn "This message was written on the 24th of March 2013, if it"
	ewarn "has been fixed upstream or you know a way to fix it please"
	ewarn "let us know at the proaudio@lists.tuxfamily.org mailing list."
}

pkg_pretend() {
	display_warning
}

src_compile() {
	base_src_compile CXX=$(tc-getCXX) CFLAGS="${CFLAGS}"
}

pkg_postinst() {
	display_warning
}
