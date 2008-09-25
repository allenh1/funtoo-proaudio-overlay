# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Gtkmm/Gnomecanvasmm widget for boxes and lines environments"
HOMEPAGE="http://wiki.drobilla.net/FlowCanvas"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

RDEPEND="dev-libs/boost
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/libgnomecanvasmm-2.6
	media-gfx/graphviz"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"
#S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	export WANT_AUTOMAKE="1.10"
	cd "${S}/${PN}" || die "source for ${PN} not found"
	NOCONFIGURE=1 ./autogen.sh
	econf $(use_enable debug) \
		$(use_enable doc documentation)
	emake || die "make failed"
	if use doc; then
		emake docs || die "make docs failed"
	fi
}

src_install() {
	cd "${S}/${PN}" || die "binaries for ${PN} not found"
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README ChangeLog NEWS
	use doc && dohtml -r doc/html/*
}
