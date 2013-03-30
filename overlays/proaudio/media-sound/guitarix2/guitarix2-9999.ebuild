# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils git-2 multilib

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
EGIT_REPO_URI="git://git.code.sf.net/p/guitarix/git/"
HOMEPAGE="http://guitarix.sourceforge.net/"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE="+capture +convolver faust +meterbridge"

RDEPEND="
	>=dev-libs/boost-1.38
	media-libs/ladspa-sdk
	>=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.109.1
	media-sound/lame
	media-sound/vorbis-tools
	>=x11-libs/gtk+-2.12.0
	>=media-libs/lv2-1.2.0
	capture? ( media-sound/jack_capture )
	convolver? ( media-libs/zita-convolver )
	faust? ( dev-lang/faust )
	meterbridge? ( media-sound/meterbridge )
	!media-sound/guitarix"

S="${WORKDIR}/guitarix-${PV}/"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	cd "${S}/trunk"
	./waf configure --prefix=/usr --ladspadir=/usr/share/ladspa \
	--build-lv2 --lv2dir=/usr/$(get_libdir)/lv2 || die
}

src_compile() {
	cd "${S}/trunk"
	./waf build || die
}

src_install() {
	cd "${S}/trunk"
	DESTDIR=${D} ./waf install
}
