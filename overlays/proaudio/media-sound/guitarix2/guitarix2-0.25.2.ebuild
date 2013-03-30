# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# We cannot use waf-utils eclass because the waf binary is old!
# Version is 1.5.18. Written March 30 2013
inherit base eutils multilib multiprocessing

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
SRC_URI="mirror://sourceforge/guitarix/guitarix/${P}.tar.bz2"
HOMEPAGE="http://guitarix.sourceforge.net/"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="+capture +convolver faust glade ladspa lv2 +meterbridge nls python"

RDEPEND="
	>=dev-cpp/glibmm-2.24.0
	>=dev-cpp/gtkmm-2.20.0
	>=dev-libs/boost-1.38
	dev-libs/glib
	media-libs/liblrdf
	>=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.109.1
	media-sound/lame
	media-sound/vorbis-tools
	>=sci-libs/fftw-3.1.2
	>=x11-libs/gtk+-2.20.0
	capture? ( media-sound/jack_capture )
	convolver? ( media-libs/zita-convolver )
	faust? ( dev-lang/faust )
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( || ( media-libs/lv2core >=media-libs/lv2-1.2.0 ) )
	meterbridge? ( media-sound/meterbridge )"
DEPEND="${RDEPEND}
	dev-lang/python
	virtual/pkgconfig
	nls? ( dev-util/intltool )"
S="${WORKDIR}/guitarix-${PV}"

DOCS=( changelog README )

PATCHES=(
	"${FILESDIR}/${P}-no-update-desktop-database.patch"
	"${FILESDIR}/${P}-no-ldconfig.patch"
	"${FILESDIR}/${P}-respect-libdir.patch"
)

src_configure() {
	# About all gentoo packages install necessary libraries and headers
	# and so should this package, hence force enable.
	local mywafconfargs=(
		--shared-lib
		--lib-dev
		$(use_enable nls)
	)
	use faust && mywafconfargs+=( --faust )
	use faust || mywafconfargs+=( --no-faust )
	use glade && mywafconfargs+=( --glade-support )
	use ladspa && mywafconfargs+=( "--ladspadir=${EPREFIX}/usr/share/ladspa" )
	use ladspa || mywafconfargs+=( --no-ladspa )
	use lv2 && mywafconfargs+=(
		--build-lv2
		"--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2"
	)
	use python && mywafconfargs+=( --python-wrapper )

	# respect libdir patch makes waf look for LIBDIR in the environment
	# instead of overriding it completely 
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"

	tc-export AR CC CPP CXX RANLIB
	echo "CCFLAGS=\"${CFLAGS}\" LINKFLAGS=\"${LDFLAGS}\" ./waf --prefix=${EPREFIX}/usr ${mywafconfargs[@]} $@ configure"
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" ./waf \
		"--prefix=${EPREFIX}/usr" ${mywafconfargs[@]} \
		configure || die "configure failed"
}

src_compile() {
	./waf "--jobs=$(makeopts_jobs)" || die "build failed"
}

src_install() {
	./waf "--destdir=${D}" install || die "install failed"

	base_src_install_docs
}
