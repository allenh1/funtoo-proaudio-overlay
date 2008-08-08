# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa examples jack midi oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	midi? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	dev-lang/perl"

pkg_setup() {
	if use midi && ! built_with_use media-libs/alsa-lib midi; then
		eerror "You need to compile media-libs/alsa-lib with USE=\"midi\""
		eerror "in order to get midi suppport in STK"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-cflags-lib.patch"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-fpic.patch"
	epatch "${FILESDIR}/${P}-missing.patch"
	eautoreconf
}
		
src_compile() {
	econf \
		`use_with alsa` \
		`use_with jack` \
		`use_with oss` \
		RAWWAVE_PATH=/usr/share/stk/rawwaves/ \
		|| die "configure failed!"

	# compile libstk
	cd src
	emake || die "make in src failed!"

	# compile examples and projects
	if use examples; then
		cd ../projects
		for i in demo effects examples ragamatic; do
			einfo "Compiling $i ..."
			cd $i
			emake || die
			rm -f Release/*.o
			cd ..
		done
	fi
	# fix include paths
	find . -type f -name Makefile\* -exec \
		perl -p -i -e "s|../../src|/usr/share/stk/src|g" {} \;
}

src_install() {
	dodoc README
	# install the lib
	dolib src/libstk.so*
	# install headers
	insinto /usr/include/stk
	doins include/*.h include/*.msg include/*.tbl
	# install rawwaves
	insinto /usr/share/stk/rawwaves
	doins rawwaves/*.raw
	if use examples; then
		# this one actually sucks, but..
		for i in *.bat *.cpp *.h Makefile*; do
			find projects/ -name $i -exec rm -f {} \;
		done
		dodir /usr/share/"${PN}"
		doins -r projects
	fi
}

