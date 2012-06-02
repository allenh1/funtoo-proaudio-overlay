# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit base autotools flag-o-matic eutils

DESCRIPTION="Rakarrack is a richly featured multi-effects processor emulating a uitar effects pedalboard."
HOMEPAGE="http://rakarrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/rakarrack/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/fltk:1
	x11-libs/libXpm
	>=media-libs/alsa-lib-0.9
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-sound/alsa-utils-0.9
	>=media-sound/jack-audio-connection-kit-0.100.0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}

#DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}/${P}_configure.patch" || die "conf patch failed"
}

src_configure() {
#	append-ldflags -L/usr/lib/fltk-1.1
#	"${S}/configure"
	econf || die "conf patch failed"
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
