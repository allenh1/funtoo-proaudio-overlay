# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-libs/aubio/aubio-0.2.0.ebuild,v 1.1.1.1 2006/04/10 11:20:47 gimpel Exp $

inherit eutils # lash

IUSE="alsa jack"

RESTRICT="nomirror"
DESCRIPTION="library for audio labelling"
HOMEPAGE="http://aubio.piem.org"
SRC_URI="http://aubio.piem.org/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="=sci-libs/fftw-3*
	    >=dev-util/pkgconfig-0.9.0
		media-libs/libsndfile
		media-libs/libsamplerate
		alsa? ( media-libs/alsa-lib )
		jack? ( media-sound/jack-audio-connection-kit )"
#		lash? ( >media-sound/lash )"

src_unpack() {
	unpack ${P}.tar.gz || die
	cd ${S}
	for i in `grep -R -l aubio_pitchm_bin *`;do
		sed -i 's/aubio_pitchm_bin/aubio_pitchm_abin/g' "${i}"
	done
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
