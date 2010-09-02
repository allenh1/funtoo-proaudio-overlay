# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Instrument editor for the Gigasampler format"
HOMEPAGE="http://www.linuxsampler.org"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-cpp/gtkmm-2.4
	>=media-libs/libgig-3.2.1
	media-libs/libsndfile
	dev-lang/perl
	dev-perl/XML-Parser
	>=media-sound/linuxsampler-0.5.1"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9
	nls? ( sys-devel/gettext
		dev-util/intltool )"

src_compile() {
	econf || die
	# fails with parallel jobs
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README NEWS AUTHORS ChangeLog
}
