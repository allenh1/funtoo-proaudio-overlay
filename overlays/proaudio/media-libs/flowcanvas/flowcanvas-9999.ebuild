# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="FlowCanvas is a canvas widget for dataflow systems"
HOMEPAGE="http://drobilla.net/software/flowcanvas"

#ECVS_SERVER="cvs.savannah.nongnu.org:/sources/om-synth"
#ECVS_MODULE="flowcanvas"
ESVN_REPO_URI="http://svn.drobilla.net/lad/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=">=dev-cpp/gtkmm-2.4
		>=dev-cpp/libgnomecanvasmm-2.6
		dev-libs/boost"
#S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	NOCONFIGURE=1 ./autogen.sh
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README ChangeLog NEWS
}
