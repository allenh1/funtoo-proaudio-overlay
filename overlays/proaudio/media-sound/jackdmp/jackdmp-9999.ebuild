# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"
RESTRICT="nomirror"
inherit unpacker fetch-tools subversion

MY_P=${P/-/_}
DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"
SRC_URI=""
ESVN_REPO_URI="http://subversion.jackaudio.org/jackmp/trunk/jackmp"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

#S="${WORKDIR}/${PN}_${PV}/src/linux"
S=${WORKDIR}/linux
src_unpack() {
	subversion_src_unpack
	cd ${S}/linux/
	# set DESTDIR and remove libjack replacing as we
	# use pkg_post* to accomplish that
	sed -i -e "s@^prefix.*@prefix := \$(DESTDIR)/usr@" \
		-e "s@.*ldconfig.*@@g" -e "s@.*libjack.so.*@@g" Makefile 
	# fix ADDON_DIR
	sed -i -e 's@#define ADDON_DIR.*@#define ADDON_DIR \"/usr/lib/jackmp\"@' \
	../common/JackDriverLoader.cpp
}

src_compile() {
	cd linux/
	emake || die
}

src_install() {
	cd linux/
	dodir /usr/bin /usr/lib/jackmp
	make DESTDIR=${D} datadir=/usr/share/doc install || die	
	cd ${S}
	use doc && einfo "generating dox" && doxygen doxyfile &>/dev/null
	use doc && dohtml html/*
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO Todo
}

pkg_postinst() {
	# replace libjack with libjackmp and set symlinks
	cd ${ROOT}/usr/lib
	# fetch libjack filename
	local jacklib="$(find -name 'libjack.so*' -type f -printf "%f\n")" 
	# rm stale sym
	[ -L "${jacklib}" ] && rm -f "${jacklib}"
	# mv libjack to tmp_jacklib and set symlinks to libjackmp
	[ -f "${jacklib}" ] && mv -f "${jacklib}" "tmp_${jacklib}" \
	&& einfo "Jacklib found, replacing it..." || einfo "Jacklib not found, continue..."
	rm -f libjack.so*
	ln -s libjackmp.so  libjack.so
	ln -s libjackmp.so  libjack.so.0

	# replace jackd with jackdmp and set symlinks
	cd ${ROOT}/usr/bin
	local jackd="jackd"
	# rm stale sym
	[ -L "${jackd}" ] && rm -f "${jackd}"
	# mv jackd to tmp_jackd and set symlink to jackdmp
	[ -f "${jackd}" ] && mv -f ${jackd} tmp_${jackd} \
	&& einfo "jackd found, replacing it..." || einfo "jackd not found, continue..."
	rm -f ${jackd}
	ln -s jackdmp ${jackd}
	ewarn "WARNING: Some application may not work with jackdmp"
}

pkg_postrm() {
	# remove old symlinks and restore libjack
	cd ${ROOT}/usr/lib
	local jacklib="$(find -name 'libjack.so*' -type f -printf "%f\n")"
	if [ ! -f "${jacklib}" ];then
		rm -f libjack.so*
		local tjacklib="$(find -name 'tmp_libjack.so*' -type f -printf "%f\n")"
		[ -f "${tjacklib}" ] && mv -f "${tjacklib}" "${tjacklib/tmp_/}" \
		&& ln -s "${tjacklib/tmp_/}" libjack.so && ln -s ${tjacklib/tmp_/} libjack.so.0 \
		&& einfo "Jacklib restored" || einfo "Jacklib not restored"
	else
		# case that jack-audio-connection was updated/installed
		# after jackdmp was installed
		einfo "new Jacklib detected, no restoring"
		local tjacklib="$(find -name 'tmp_libjack.so*' -type f -printf "%f\n")"	
		[ -f "${tjacklib}" ] && rm -f "${tjacklib}"
	fi

	cd ${ROOT}/usr/bin
	# remove old symlinks and restore jackd
	local jackd="jackd"

	has_version "media-sound/jack-audio-connection-kit" \
	&& [ -f "tmp_${jackd}" ] && [ -L "${jackd}" ] \
	&& mv -f "tmp_${jackd}" "${jackd}" \
	&& einfo "jackd restored" || einfo "jackd not restored"
	[ -L "${jackd}" ] && rm -f "${jackd}"
	[ -f "tmp_${jackd}" ] && rm -f "tmp_${jackd}"
}
