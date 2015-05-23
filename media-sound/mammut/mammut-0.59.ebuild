# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

RESTRICT="mirror"
DESCRIPTION="A program for doing sound effects using one gigantic fft analysis (no windows)."
HOMEPAGE="http://www.notam02.no/arkiv/doc/mammut/"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="doc"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.100
	media-libs/libsndfile
	>=media-libs/juce-1.40
	>=media-libs/libsamplerate-0.1.1
	media-libs/libvorbis
	media-libs/mesa
	|| ( (  x11-proto/xineramaproto
			x11-proto/xextproto
			x11-proto/xproto )
		virtual/x11 )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"/src
	# fix Makefile
	cp Makefile.linux Makefile
	sed -i -e "s:INSTALLPATH=/usr/local:INSTALLPATH=\$(DESTDIR)/usr:" Makefile \
		|| die
	sed -i -e "s:JUCE=../../juce:JUCE=/usr/include/juce:" Makefile \
		|| die
	sed -i -e "s:GCC=gcc -Wall:GCC=gcc -Wall -march=$(get-flag march):" Makefile \
		|| die

	# fix for juce-1.42
	has_version ">media-libs/juce-1.41" && "epatch ${FILESDIR}/${P}-prefs.patch"
}

src_compile() {
	cd "${S}/src"
	emake || die "make failed"
}

src_install() {
	# install doc
	if use doc; then
		dodoc doc/mammuthelp.html
	fi

	# install binary
	dobin src/"${PN}"

	# create desktop entry
	newicon "icons/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Mammut" "${PN}" "AudioVideo;Audio;"
}
