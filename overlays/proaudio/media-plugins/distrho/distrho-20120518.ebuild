# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base multilib toolchain-funcs

DESCRIPTION="Open-source project that provides Cross-Platform Audio Plugins using Juce and Qt4"
HOMEPAGE="http://distrho.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Source/${P}.tar.bz2
https://launchpad.net/~kxstudio-team/+archive/plugins/+files/${PN}_${PV}-0~precise2.debian.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lv2 standalone"
REQUIRED_USE="|| ( lv2 standalone )"

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sci-libs/fftw:3.0
	x11-libs/libX11
	x11-libs/libXext
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	=dev-util/premake-3.7
	sys-apps/findutils
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	# kxstudio patches
	epatch "${WORKDIR}"/debian/patches/*.patch

	# turn on verbose Makefile generation so we can see compiler and flags used
	epatch "${FILESDIR}"/${P}-verbose-makefiles.patch

	base_src_prepare

	# FIXME: try to remove forced compiler flags and prevent stripping
	find . -type f -name premake.lua \
		-exec sed -i -e "s/-O2//g" -e "s/-O3//g" \
		-e "s/-mtune=generic//g" -e "s/-msse//g" \
		-e "s/-fomit-frame-pointer//g" \
		-e "s/\"no-symbols\",//g" -e "s/\"optimize-speed\"//g" '{}' \; || die
}

src_configure() {
	./scripts/premake-update.sh linux || die
}

src_compile() {
	tc-export CC CXX

	use standalone && base_src_make standalone

	if use lv2; then
		base_src_make lv2

		# work around failure generating HybridReverb2.lv2 ttl files
		mkdir -p bin/lv2/HybridReverb2.lv2/ || die
		cp "${WORKDIR}"/debian/HybridReverb2.lv2/*.ttl \
			bin/lv2/HybridReverb2.lv2/ || die

		base_src_make gen
	fi

	#use vst && base_src_make vst
}

src_install() {
	use standalone && dobin bin/standalone/*

	if use lv2; then
		insinto /usr/$(get_libdir)/lv2
		doins -r bin/lv2/*.lv2
	fi

	#if use vst; then
	#	exeinto /usr/$(get_libdir)/vst
	#	doexe bin/vst/*
	#fi

	insinto /etc/HybridReverb2
	doins ports/hybridreverb2/data/HybridReverb2.conf

	insinto /usr/share
	doins -r ports/hybridreverb2/data/HybridReverb2
}
