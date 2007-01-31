# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-libs/aubio/aubio-0.2.0-r1.ebuild,v 1.1.1.1 2006/04/10 11:20:46 gimpel Exp $

inherit eutils # lash

IUSE="alsa jack"

RESTRICT="nomirror"
DESCRIPTION="library for audio labelling"
HOMEPAGE="http://aubio.piem.org"
SRC_URI="http://aubio.piem.org/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND="=sci-libs/fftw-3*
	    >=dev-util/pkgconfig-0.9.0
		media-libs/libsndfile
		media-libs/libsamplerate
		python? ( >=dev-lang/swig-1.3.0 )
		alsa? ( media-libs/alsa-lib )
		jack? ( media-sound/jack-audio-connection-kit )"
#		lash? ( >media-sound/lash )"

src_unpack() {
	unpack ${P}.tar.gz || die
	cd ${S}
#	ladcca_to_lash
}

src_compile() {
	econf `use_enable jack` `use_enable alsa` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
