# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="GStreamer plugin used by buzztard"
HOMEPAGE="http://www.buzztard.org"
SRC_URI="mirror://sourceforge/buzztard/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bml fluidsynth"

RDEPEND=">=media-libs/gstreamer-0.10.11
	>=media-libs/gst-plugins-base-0.10.0
	>=media-libs/gst-plugins-good-0.10.0
	bml? ( >=media-libs/bml-${PV} )
	fluidsynth? ( media-sound/fluidsynth )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-no-automagic-deps.patch"
	eautoreconf
}

src_compile() {
	econf $(use_with bml) $(use_with fluidsynth) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}
