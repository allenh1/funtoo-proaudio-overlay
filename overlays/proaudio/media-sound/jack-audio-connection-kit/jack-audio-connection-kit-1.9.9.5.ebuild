# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"

inherit multilib python eutils

RESTRICT="mirror"
DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="https://dl.dropbox.com/u/28869550/jack-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus debug doc freebob ieee1394 mixed"

RDEPEND="alsa? ( >=media-libs/alsa-lib-0.9.1 )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	dbus? ( sys-apps/dbus )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/jack-${PV}"

pkg_pretend() {
	if use mixed; then
		ewarn 'You are about to build with "mixed" use flag.'
		ewarn 'The build will probably fail.'
		ewarn 'If you know how to properly build 32bit lib on 64bit system,'
		ewarn 'please help with fixing the bug.'
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/jack2-no-self-connect-1.9.9.5.patch"
	epatch "${FILESDIR}/jack-1.9.9.5-opus_custom.patch"
}

src_configure() {
	local myconf="--prefix=/usr --destdir=${D}"
	use alsa && myconf="${myconf} --alsa"
	use dbus && myconf="${myconf} --dbus"
	! use dbus && myconf="${myconf} --classic"
	use debug && myconf="${myconf} -d debug"
	use doc && myconf="${myconf} --doxygen"
	use freebob && myconf="${myconf} --freebob"
	use ieee1394 && myconf="${myconf} --firewire"
	use mixed && myconf="${myconf} --mixed"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
}

src_compile() {
	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	ln -s ../../html build/default/html
	./waf --destdir="${D}" install || die "waf install failed"
	python_convert_shebangs -r 2 "${ED}"
}
