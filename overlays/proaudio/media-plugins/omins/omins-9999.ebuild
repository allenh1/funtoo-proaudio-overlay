# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils multilib

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"

IUSE=""
DESCRIPTION="Collection of LADSPA plugins for modular synthesizers."
HOMEPAGE="http://drobilla.net/software"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND="media-libs/ladspa-sdk
	>=media-libs/liblo-0.2.5
	sci-libs/fftw
	>=dev-libs/redland-1.0.6"

src_compile() {
	cd ${PN}/src
	scons || die "scons failed"
}

src_install() {
	cd ${PN}
	dodoc NEWS AUTHORS README ChangeLog
	
	cd src
	dodir /usr/$(get_libdir)/ladspa
	into /usr/$(get_libdir)/ladspa
	dolib *.so
}
