# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features."
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jack"

RDEPEND=">=media-libs/liblscp-0.5.5
	>=media-libs/libgig-3.1.1
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"

DEPEND="${RDEPEND}"

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
}
