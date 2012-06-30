# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils unpacker

KEYWORDS="amd64 ~ppc x86"
IUSE="lash oss alsa jack"

MY_P=ZynAddSubFX-${PV}
DESCRIPTION="ZynAddSubFX-converter: use ONLY to convert old *.ins_zyn instruments to *.xiz"
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=x11-libs/fltk-1.1.2
	=sci-libs/fftw-3*
	jack? ( media-sound/jack-audio-connection-kit )
	>=dev-libs/mini-xml-2.2.1"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.bz2 || die
	unpacker "${FILESDIR}/${PN}-patches.tar.gz"

	# fixup patchlevel
	sed -i -e \
		's@/var/tmp/portage/media-sound/zynaddsubfx-converter-2.0.0_pre2/work/ZynAddSubFX-2.0.0_pre2/@@g' \
		"$WORKDIR/03_add-warning.patch"

	cd "${S}"
	EPATCH_SOURCE="${WORKDIR}" EPATCH_SUFFIX="patch"\
	EPATCH_FORCE="yes" epatch
	#cp  ${S}/src/UI/MasterUI.fl ${S}/src/UI/MasterUI.fl.orig
	#cp /home/evermind/MasterUI.fl ${S}/src/UI/
	#diff -u src/UI/MasterUI.fl.orig src/UI/MasterUI.fl > /tmp/Masterdirr.patch
	#chmod 644 /tmp/Masterdirr.patch
}

src_compile() {
	local FFTW_VERSION=3
	local ASM_F2I=NO
	local LINUX_MIDIIN=NONE
	local LINUX_AUDIOOUT=NONE
	local LINUX_USE_LASH=NO

	if use oss ; then
		LINUX_MIDIIN=OSS
		LINUX_AUDIOOUT=OSS
		use jack && LINUX_AUDIOOUT=OSS_AND_JACK
	else
		use jack && LINUX_AUDIOOUT=JACK
	fi

	use lash && LINUX_USE_LASH=YES

	use alsa && LINUX_MIDIIN=ALSA
#	use portaudio && LINUX_AUDIOOUT=PA
#	use mmx && ASM_F2I=YES

	cd ${S}/src
	make \
		FFTW_VERSION=${FFTW_VERSION} \
		ASM_F2I=${ASM_F2I} \
		LINUX_MIDIIN=${LINUX_MIDIIN} \
		LINUX_AUDIOOUT=${LINUX_AUDIOOUT} \
		LINUX_USE_LASH=${LINUX_USE_LASH} \
		|| die "compile failed"
}

src_install() {
	newbin ${S}/src/zynaddsubfx zynaddsubfx-converter
	dodoc ${WORKDIR}/README
}

pkg_postinst() {
	eerror "use ONLY to convert old *.ins_zyn instruments to *.xiz"
}
