# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

ESVN_REPO_URI="http://subversion.jackaudio.org/jackmp/trunk/jackmp/"
RESTRICT="nomirror ccache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc debug examples freebob"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1
	freebob? ( sys-libs/libfreebob )"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/scons
	doc? ( app-doc/doxygen )"

src_compile() {
	local myconf="PREFIX=/usr"
	use freebob || myconf="${myconf} ENABLE_FREEBOB=False ENABLE_FIREWIRE=False"
	use debug || myconf="${myconf} DEBUG=False"
	use doc || myconf="${myconf} BUILD_DOXYGEN_DOCS=False"
	use examples || myconf="${myconf} BUILD_EXAMPLES=False"
	scons ${myconf} || die
}

src_install() {
	cd linux/
	dodir /usr/bin /usr/lib/jackmp
	make DESTDIR="${D}" datadir=/usr/share/doc install || die
	cd ${S}

	dosym /usr/lib/libjackmp.so /usr/lib/libjack.so
	dosym /usr/lib/libjackmp.so /usr/lib/libjack.so.0

	dodoc Readme Todo ChangeLog
}

pkg_postinst() {
	local provided="${ROOT}/etc/portage/profile/package.provided"
	
	test -d ${ROOT}/etc/portage/profile \
		|| dodir /etc/portage/profile

	if [ -z `grep "media-sound/jack-audio-connection-kit-0.109.0" ${provided}` ]
	then
		elog "Adding media-sound/jack-audio-connection-kit to"
		elog "/etc/portage/profile/package.provided ..."
		elog "Note that a lot of things might not compile correctly"
		elog "against jackdmp's jack headers!"

		echo "media-sound/jack-audio-connection-kit-0.109.0" >> ${provided}
	fi
}

pkg_postrm() {
	# gets removed too when upgrading jackdmp, so let the user do it!
	elog "*************** IMPORTANT ******************"
	elog "PLEASE remove media-sound/jack-audio-connection-kit from"
	elog "/etc/portage/profile/package.provided"
	elog "if you switch to jack-audio-connection-kit again!!"
	elog "Otherwhise you will mess up dependencies!"

	#sed '/media-sound\/jack-audio-connection-kit-0.109.0/d' \
	#	-i ${ROOT}/etc/portage/profile/package.provided
}
