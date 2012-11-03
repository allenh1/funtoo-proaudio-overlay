# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools subversion

IUSE="alsa dbus debug doc double jack ladspa lash oss portaudio pulseaudio readline sndfile"

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.6.5
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		  >=media-libs/ladspa-cmt-1.15 )
	alsa? ( media-libs/alsa-lib
		lash? ( >=media-sound/lash-0.5 ) )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
	portaudio? ( >=media-libs/portaudio-19_pre )
	readline? ( sys-libs/readline )
	dbus? ( sys-apps/dbus )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use lash && ! use alsa; then
		ewarn "ALSA support is required for lash support to be enabled."
		ewarn "Continuing with lash support disabled."
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myopts=""

	if use alsa; then
		myopts="$(use_enable lash)"
	else
		myopts="--disable-lash"
	fi

	myopts+="
	$(use_enable double)
	$(use_enable ladspa)
	$(use_enable debug)
	$(use_enable sndfile libsndfile-support)
	$(use_enable pulseaudio pulse-support)
	$(use_enable alsa alsa-support)
	$(use_enable portaudio portaudio-support)
	$(use_enable jack jack-support)
	$(use_with readline)
	$(use_enable dbus dbus-support)"

	econf $myopts
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install"
	dodoc AUTHORS NEWS README THANKS TODO doc/*.txt
	insinto /usr/share/doc/${PF}/pdf
	doins doc/*.pdf

	if use doc; then
		cd doc
		make doxygen
		insinto /usr/share/doc/${PF}/html
		doins api/html/*
	fi
}
