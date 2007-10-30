# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools cvs unpacker

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"
SRC_URI=""
ECVS_SERVER="rezound.cvs.sourceforge.net:/cvsroot/rezound"
ECVS_MODULE="rezound"

S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="16bittmp alsa flac jack nls oss portaudio soundtouch vorbis"

RDEPEND="=sci-libs/fftw-2*
	>=x11-libs/fox-1.6.14
	>=dev-util/reswrap-3.2.0
	>=media-libs/audiofile-0.2.3
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/ladspa-cmt-1.15
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-18 )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )"

DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/bison
	sys-devel/flex"

src_unpack() {
	cvs_src_unpack
	unpacker "${FILESDIR}/rezound-0.12.2_beta-patches.tar.bz2"
	cd "${S}"
	EPATCH_EXCLUDE="40_rezound-0.12.2_beta-float.patch 50_rezound-0.12.2_beta-64bits.patch 20_rezound-0.12.2_beta-gcc4.patch 30_rezound-0.12.2_beta-fox-1.6.patch rezound-0.12.2_beta-foxinclude.patch" \
	EPATCH_SOURCE="${WORKDIR}" EPATCH_SUFFIX="patch"\
	EPATCH_FORCE="yes" epatch
	
	# fix for >=flac-1.2
	has_version ">media-libs/flac-1.1.4" && epatch ${FILESDIR}/${PN}-flac-1.2.patch

	./bootstrap

	# add missing Makefile.in.in to po/
	[ ! -e po/Makefile.in.in ] && gzip -cdf  "${FILESDIR}"/Makefile.in.in.gz > po/Makefile.in.in
}

src_compile() {
	# fix compilation errors on ppc, where some
	# of the required functions aren't defined
	test "${ARCH}" = ppc && epatch ${FILESDIR}/undefined-functions.patch

	# following features can't be disabled if already installed:
	# -> flac, oggvorbis, soundtouch <-- why not? I've added missing flags
	local sampletype="--enable-internal-sample-type=float"
	use 16bittmp && sampletype="--enable-internal-sample-type=int16"

	econf \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_with flac libFLAC) \
		$(use_enable soundtouch soundtouch-check) \
		$(use_with ogg ) \
		$(use_with vorbis ) \
		${sampletype} \
		--enable-ladspa \
		--enable-largefile \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# remove wrong doc directory
	rm -rf "${D}/usr/doc"

	dodoc docs/{AUTHORS,NEWS,README*}
	dodoc docs/{TODO_FOR_USERS_TO_READ,*.txt}
	newdoc README README.rezound

	docinto code
	dodoc docs/code/*
	newicon src/images/icon_logo_32.gif rezound.gif
	make_desktop_entry rezound Rezound rezound.gif AudioVideo
}
