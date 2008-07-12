# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
DESCRIPTION="FlowCanvas is a canvas widget for dataflow systems"
HOMEPAGE="http://wiki.drobilla.net/FlowCanvas"
SRC_URI="http://download.drobilla.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-cpp/gtkmm-2.4
		>=dev-cpp/libgnomecanvasmm-2.6
		dev-libs/boost"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	econf --enable-anti-aliasing || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README ChangeLog NEWS
}
