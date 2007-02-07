# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde-functions patcher autotools multilib

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net/"
SRC_URI="mirror://sourceforge/hydrogen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="alsa debug jack ladspa oss portaudio"

RDEPEND="dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	media-libs/flac
	portaudio? ( =media-libs/portaudio-18.1* )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )"

	#  disabled
DEPEND="${RDEPEND}"
	# app-text/docbook-sgml-utils is only needed to support:
	# data/doc/updateManuals.sh (we don't run this)


need-qt 3

src_unpack() {
	unpack ${A}
	if use ppc; then
		cd ${S}/src
		epatch ${FILESDIR}/0.9.1-OSS.patch || die "patching failed"
	fi
	cd ${S}
	# fix gcc 4 issue
	sed -i -e 's|TiXmlDeclaration::TiXmlDeclaration|TiXmlDeclaration|g' src/lib/xml/tinyxml.h 

	mv data/doc/man ${S}
	# broken or portability issue
	find . -iname Makefile.in -exec sed -i -e "s:update-menus::" {} \;
		sed -e "s:lib/hydrogen:$(get_libdir)/hydrogen:g" -i plugins/wasp/Makefile.in
	### fix broken portaudio-18 include (if portaudio-19 also installed)
	if use portaudio ;then
		# find PortAudio/Midi files
		sed -e "s:pa_unix_oss:lib:g" -e "s:pa_common:include:g" \
			-e "s:pm_linux:lib:g" -e "s:pm_common:include:g" \
			-i configure.in

		grep -q PortAudioStream /usr/include/portaudio/portaudio.h && \
			sed -i 's@\(#include\ *<\)\(portaudio.*\)@\1portaudio/\2@g' \
			src/lib/drivers/PortAudioDriver.h
	fi ###

	# configure.in.patch [20070109] fixes use_enable debug
	patcher "${FILESDIR}/hydrogen-0.9.2-configure.in.patch apply"
	
	# fixes a segfault while changing pattern change
	# see bug: http://proaudio.tuxfamily.org/bugs/view.php?id=2
	patcher "${FILESDIR}/hydrogen-0.9.3-segfault.patch apply"
	
	make -f Makefile.cvs
}

src_compile() {
	need-autoconf 2.5

	export PORTAUDIOPATH="${ROOT}usr"
	# PortMidi not yet in the repository
	# export PORTMIDIPATH="${ROOT}usr"

	econf $(use_enable jack jack-support) \
			$(use_enable portaudio) \
			$(use_enable alsa) \
			$(use_enable debug) \
			$(use_enable ladspa) \
			$(use_enable ladspa lrdf-support) \
			$(use_enable oss oss-support) \
	econf || die "Failed configuring hydrogen!"
	emake -j1 || die "Failed making hydrogen!"
}

src_install() {
	pushd data/i18n
	./updateTranslations.sh
	rm *.ts updateTranslations.sh
	popd

	pushd data/doc
	./updateManuals.sh
	rm *.docbook updateManuals.sh
	popd

	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
	dosym /usr/share/hydrogen/data/doc /usr/share/doc/${PF}/html
	doman man/C/hydrogen.1

	for N in 16 24 32 48 64 ; do
		dodir /usr/share/icons/hicolor/${N}x${N}/apps
		dosym /usr/share/hydrogen/data/img/gray/icon${N}.png \
			 /usr/share/icons/hicolor/${N}x${N}/apps/hydrogen.png
	done
	dodir /usr/share/icons/hicolor/scalable/apps
	dosym /usr/share/hydrogen/data/img/gray/icon.svg \
		/usr/share/icons/hicolor/scalable/apps/hydrogen.svg
}
