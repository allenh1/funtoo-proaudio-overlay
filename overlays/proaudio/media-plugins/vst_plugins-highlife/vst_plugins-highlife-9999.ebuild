# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion vstplugin multilib flag-o-matic

DESCRIPTION="discoDSP's Highlife VST sampler"
HOMEPAGE="http://www.anticore.org/jucetice/?p=55"

ESVN_REPO_URI="svn://jacklab.net/eXT2/vstplugins/highlife"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/juce
	=media-libs/freetype-2*
	virtual/opengl
	media-libs/alsa-lib
	amd64? ( app-emulation/emul-linux-x86-xlibs )"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	if use amd64; then
		sed -i \
			-e 's@/usr/X11R6/lib@/usr/X11R6/lib32@g' \
			-e 's@/usr/lib@/usr/lib32@g' \
			highlife.make || die
	fi
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86
	append-flags -fPIC -DPIC
	append-ldflags -fPIC -DPIC
	emake CONFIG=Release || die
}

src_install() {
	insinto /usr/$(get_libdir)/vst
	doins bin/*.so
}
