# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils scons-utils toolchain-funcs

DESCRIPTION="A MIDI tracker for the Jack Audio Connection Kit"
HOMEPAGE="http://www.bitbucket.org/paniq/jacker"
SRC_URI="http://www.bitbucket.org/paniq/${PN}/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

RDEPEND=">=dev-cpp/gtkmm-2.18.2:2.4
	>=media-sound/jack-audio-connection-kit-0.118.0"
DEPEND="${RDEPEND}"

src_compile() {
	# obey CXX, CXXFLAGS and LDFLAGS
	epatch "${FILESDIR}/${P}-sconstruct.patch"

	tc-export CXX
	escons DEBUG=$(use debug && echo 1 || echo 0) \
		VERBOSE=1 || die "escons compile failed"
}

src_install() {
	escons DESTDIR="${D}" PREFIX=/usr install || die "escons install failed"

	# remove the text files in /usr/share/jacker and use dodoc on them instead,
	# it's tidier on Gentoo plus dodoc compresses them
	rm "${D}/usr/share/jacker/cheatsheet.txt"
	rm "${D}/usr/share/jacker/commands.txt"
	dodoc cheatsheet.txt commands.txt todo.txt

	# a desktop entry for convenience
	dosym /usr/share/jacker/jacker.png /usr/share/pixmaps/jacker.png
	make_desktop_entry jacker Jacker jacker "AudioVideo;Audio;Sequencer;"
}
