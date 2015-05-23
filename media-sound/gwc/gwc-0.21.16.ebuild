# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="alsa oss singlefft"

inherit eutils versionator
RESTRICT="mirror"
DESCRIPTION="Gnome Wave Cleaner"
HOMEPAGE="http://gwc.sourceforge.net/"
MY_P="${PN}-$(replace_version_separator "2" "-")"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-1"
KEYWORDS="amd64 ~ppc x86"

DEPEND=">=media-libs/libsndfile-1.0.1
	virtual/pkgconfig
	=sci-libs/fftw-3*
	x11-proto/glproto
	x11-proto/dri2proto
	>=gnome-base/libgnomeui-2.0
	alsa? ( >=media-libs/alsa-lib-0.9 )"

S="${WORKDIR}/${MY_P}"

src_unpack(){
	unpack ${A}
	cd ${S}
	# adjust to use our CFLAGS
	#sed -i -e "/^CFLAGS =/s/@CFLAGS@ -mcpu=@UNAME_MACHINE@ -march=@UNAME_MACHINE@//" -e "s/^\(CFLAGS\).*\(\=\)/\1 +=/"  Makefile.in
	sed -i -e '/^CFLAGS =/cCFLAGS +='  meschach/makefile.in
	# add DESTDIR to Makefile.in
	MYDIRS='\$(BINDIR)\|\$(pixmapdir)\|\$(HELPDIRC)\|\$(DOCDIR)'
	sed -i -e "/^DOCDIR =/c DOCDIR = \/usr\/share\/doc\/\$\{P\}" \
		-e "s:^\(HELPDIR\ \=\)\(.*GNOME)\):\1 \$\(prefix\):" \
		-e 's:install -d :install -d \$\(DESTDIR\)/:' \
		-e "/install -p/,/pixmapdir)$/ s:\($MYDIRS\):\$\(DESTDIR\)/&:" \
		Makefile.in

}

src_compile() {
	econf $(use_enable alsa) $(use_with oss) \
		$(use_enable singlefft single-fftw3) || die "Configuration failed"

	# Build the meschach math library first
	# so good CFLAGS are used
	cd ${S}/meschach
	PATH=".:$PATH"
	econf --with-sparse || die "Failed to configure meschach math-lib"
	( make part1 && make part2 && make part3 && cp machine.h ..) || die \
	            "Failed to compile meschach math-lib"

	# Now build gwc
	cd ${S}
	PATH=.:${PATH}
	emake || die
}

src_install () {
	make install DESTDIR=${D} || die
}
