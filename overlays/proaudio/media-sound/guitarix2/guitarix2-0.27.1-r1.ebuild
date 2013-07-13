# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# We cannot use waf-utils eclass because the waf binary is old!
# Version is 1.5.18. Written April 09 2013
PYTHON_COMPAT=( python2_7 )
inherit base eutils multilib multiprocessing python-any-r1

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
SRC_URI="mirror://sourceforge/guitarix/guitarix/${P}.tar.bz2"
HOMEPAGE="http://guitarix.sourceforge.net/"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="+capture custom-cflags +convolver debug faust ladspa lv2 +meterbridge nls"

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
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

S="${WORKDIR}/guitarix-${PV}"

DOCS=( changelog README )

src_configure() {
	# About all gentoo packages install necessary libraries and headers
	# and so should this package, hence force enable.
	local mywafconfargs=(
		--nocache
		--shared-lib
		--lib-dev
		--no-ldconfig
		--no-desktop-update
		$(use_enable nls)
		"--libdir=${EPREFIX}/usr/$(get_libdir)"
	)
	use custom-cflags || mywafconfargs+=( --cxxflags-release="-DNDEBUG" )
	use custom-cflags || mywafconfargs+=( --cxxflags="" )
	use debug && mywafconfargs+=( --debug )
	use debug && mywafconfargs+=( --cxxflags-debug="" )
	use faust && mywafconfargs+=( --faust )
	use faust || mywafconfargs+=( --no-faust )
	use ladspa && mywafconfargs+=( "--ladspadir=${EPREFIX}/usr/share/ladspa" )
	use ladspa || mywafconfargs+=( --no-ladspa )
	use lv2 && mywafconfargs+=(
		--build-lv2
		"--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2"
	)

	tc-export AR CC CPP CXX RANLIB
	einfo "CCFLAGS=\"${CFLAGS}\" LINKFLAGS=\"${LDFLAGS}\" ./waf --prefix=${EPREFIX}/usr ${mywafconfargs[@]} $@ configure"
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" ./waf \
		"--prefix=${EPREFIX}/usr" ${mywafconfargs[@]} \
		configure || die "configure failed"
}

src_compile() {
	local jobs="--jobs=$(makeopts_jobs)"
	einfo "./waf ${jobs}"
	./waf ${jobs} || die "build failed"
}

src_install() {
	einfo "./waf --destdir=${D}"
	./waf "--destdir=${D}" install || die "install failed"

	base_src_install_docs
}
