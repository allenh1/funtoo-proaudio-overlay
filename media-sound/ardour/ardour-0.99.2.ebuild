# Copy# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils scons-ccache

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="http://ardour.org/files/releases/${P/_/}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE="nls debug sse altivec vst"

# Ardour 0.99!
# This is the first ebuild that can be marked stable, since it's out of beta finally.

# From beta30 release notes:
#  plugin latency compensation now working correctly (we believe)
#  This really requires JACK 0.100.0 or above to work
#  properly, but even without that, they result in notable improvements
#  in the way Ardour aligns newly recorded material.
#
# As media-sound/jack-audio-connection-kit-0.100.0 is still -arch and it is not required for beta30
# only suggested, RDEPEND needs to be updated as media-sound/jack-audio-connection-kit-0.100.0 gets
# into ~arch. (2005 Sep 14 eldad)

RDEPEND="dev-util/pkgconfig
	>=media-libs/liblrdf-0.3.6
	>=media-libs/raptor-1.2.0
	>=media-sound/jack-audio-connection-kit-0.98.1
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=media-libs/libsndfile-1.0.4
	sys-libs/gdbm
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsamplerate-0.0.14
	>=dev-libs/libxml2-2.5.7
	>=media-libs/libart_lgpl-2.3.16
	!media-sound/ardour-cvs"

DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )
	vst? ( >=media-libs/fst-1.7-r3 )"

S="${WORKDIR}/${P/_/}"

src_unpack(){
	unpack ${A}
	cd ${S}
	use vst && epatch ${FILESDIR}/ardour-vst-support_0_1.patch
	use vst && epatch ${FILESDIR}/ardour-vst-support_1_1.patch
	add_ccache_to_scons
}

src_compile() {
	# bug 99664
	cd ${S}/libs/gtkmm
	chmod a+x autogen.sh && ./autogen.sh || die "autogen failed"
	econf || die "configure failed"
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	use altivec && ALTIVEC=1 || ALTIVEC=0
	use debug && ARDOUR_DEBUG=1 || ARDOUR_DEBUG=0
	use nls && NLS=1 || NLS=0
	use sse && SSE=1 || SSE=0
	use vst && VST=1 || VST=0
	FST_PATH="/usr/lib/fst"	
	
	cd ${S}
	scons \
		ALTIVEC=${ALTIVEC} \
		DEBUG=${ARDOUR_DEBUG} \
		DESTDIR=${D} \
		NLS=${NLS} \
		PREFIX=/usr \
		USE_SSE_EVERYWHERE=${SSE} \
		BUILD_SSE_OPTIMIZATIONS=${SSE} \
		KSI=0 \
		VST=${VST} VSTPATH=${FST_PATH} \
		-j2
}

src_install() {
	scons install || die "make install failed"
	use vst && dobin gtk_ardour/ardour.bin.exe.so
	use vst && fperms 644 /usr/bin/ardour.bin.exe.so
	dodoc DOCUMENTATION/*
}
