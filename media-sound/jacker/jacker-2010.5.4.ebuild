# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils toolchain-funcs

DESCRIPTION="A MIDI tracker for the Jack Audio Connection Kit"
HOMEPAGE="http://www.bitbucket.org/paniq/jacker"
SRC_URI="http://www.bitbucket.org/paniq/${PN}/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.18.2:2.4
	>=media-sound/jack-audio-connection-kit-0.118.0"
DEPEND="${RDEPEND}
	dev-util/scons"

src_compile() {
	epatch "${FILESDIR}/${P}-gcc-missing-include.patch"
	# hack to find the glade file in /usr/share/jacker instead of the location
	# of the binary. upstream intended running in build dir where files exist
	# and there is no install script
	epatch "${FILESDIR}/${P}-glade-file-location.patch"
	# obey CXX and toolchain flags
	epatch "${FILESDIR}/${P}-sconstruct.patch"

	tc-export CC CXX
	scons || die "compilation failed"
}

src_install() {
	# the scons script doesn't have an "install", hence the glade file patch
	# and this stuff...
	# just a binary in /usr/bin, glade file and image in /usr/share/jacker
	dobin jacker
	dodoc cheatsheet.txt commands.txt todo.txt

	# a desktop entry for convenience
	doicon jacker.png
	make_desktop_entry jacker Jacker jacker "AudioVideo;Audio;Sequencer;"

	# put the glade file and image in suitable place
	insinto /usr/share/jacker
	doins jacker.glade
	doins jacker.png
}
