# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="http://ccrma.stanford.edu/software/stk/"
SRC_URI="http://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa jack midi oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( media-sound/jack-audio-connection-kit )
		midi? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
		dev-lang/perl"

src_compile() {
	econf \
		`use_with alsa` \
		`use_with jack` \
		`use_with oss` \
		RAWWAVE_PATH=/usr/share/stk/rawwaves/ \
		|| die "configure failed!"

	# build the whole bunch
	cd src
	emake || die "make in src failed!"

	cd ../projects
	for i in demo effects examples ragamatic; do
		cd $i
		emake || die
		rm -f Release/*.o
		cd ..
	done

	# reconfigure to correct paths, hell knows
	cd "${S}"
	econf \
		`use_with alsa` \
		`use_with jack` \
		`use_with oss` \
		RAWWAVE_PATH=/usr/share/stk/rawwaves \
		INCLUDE_PATH=/usr/include/stk \
		|| die "re-configure failed!"

	# fix include paths
	find . -type f -name Makefile\* -exec \
		perl -p -i -e "s|../../src|/usr/share/stk/src|g" {} \;
}

src_install() {
	dodoc README STK_TODO.txt
	insinto /usr/include/stk
	doins include/*.h include/*.msg include/*.tbl
	insinto /usr/share/stk/src
	doins src/*.cpp
	insinto /usr/share/stk/rawwaves
	doins rawwaves/*.raw
	dolib src/libstk.a
	# this one actually sucks, but..
	mv projects "${D}"/usr/share/stk
}

