# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils git-2

MY_PN="libebur128"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library implementing the EBU R128 loudness standard."
HOMEPAGE="https://github.com/jiixyj/${MY_PN}"
EGIT_REPO_URI="https://github.com/jiixyj/${MY_PN}.git"
EGIT_HAS_SUBMODULES="TRUE"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="ffmpeg gstreamer musepack mp3 sndfile speex taglib"

DEPEND="dev-libs/glib:2
	dev-qt/qtgui
	dev-qt/qtsvg
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? ( media-libs/gstreamer )
	musepack? ( media-sound/musepack-tools )
	mp3? ( media-sound/mpg123 )
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex )
	taglib? ( media-libs/taglib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"