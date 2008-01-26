# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc semaphores"
RESTRICT="nomirror ccache"
inherit unpacker fetch-tools

MY_P=${P/-/_}
DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"
SRC_URI="http://www.grame.fr/~letz/${MY_P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1
	!media-sound/jack-audio-connection-kit"

DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}/src
src_unpack() {
	unpack ${A}
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
	local myconf=""
	use semaphores && myconf="SOCKET_RPC_POSIX_SEMA"
	emake || die
}

src_install() {
	cd linux/
	dodir /usr/bin /usr/lib/jackmp
	make DESTDIR="${D}" datadir=/usr/share/doc install || die
	cd ${S}
	use doc && einfo "generating dox" && doxygen doxyfile &>/dev/null
	use doc && dohtml html/*
	dodoc ../README

	dosym /usr/lib/libjackmp.so /usr/lib/libjack.so
	dosym /usr/lib/libjackmp.so /usr/lib/libjack.so.0
}

pkg_postinst() {
	elog "Adding media-sound/jack-audio-connection-kit to"
	elog "/etc/portage/profile/package.provided ..."
	elog "Note that a lot of things might not compile correctly"
	elog "against jackdmp's jack headers!"

	test -d ${ROOT}/etc/portage/profile \
		|| dodir /etc/portage/profile
	echo "media-sound/jack-audio-connection-kit-0.109.0" >> \
		${ROOT}/etc/portage/profile/package.provided
}

pkg_postrm() {
	elog "Removing media-sound/jack-audio-connection-kit from"
	elog "/etc/portage/profile/package.provided ..."

	sed '/media-sound\/jack-audio-connection-kit-0.109.0/d' \
		-i ${ROOT}/etc/portage/profile/package.provided
}
