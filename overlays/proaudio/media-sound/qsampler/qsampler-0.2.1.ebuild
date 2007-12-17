# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

DESCRIPTION="QSampler is a graphical frontend to the LinuxSampler engine."
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="$(qt4_min_version 4.1)
	>=media-libs/liblscp-0.5.5
	>=media-libs/libgig-0.3.3
	>=media-sound/linuxsampler-0.4
	media-libs/alsa-lib"

DEPEND="${RDEPEND}"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "einstall failed"
	dodoc AUTHORS ChangeLog README
}
