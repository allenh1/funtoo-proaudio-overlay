# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

ESVN_REPO_URI="http://svn.drobilla.net/lad/omins"
ESVN_PROJECT="omins"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

IUSE=""
DESCRIPTION="Collection of LADSPA plugins for modular synthesizers."
HOMEPAGE="http://drobilla.net/software"

LICENSE="GPL-2"
KEYWORDS=""

DEPEND="media-libs/ladspa-sdk
	sci-libs/fftw"

S="${WORKDIR}/${ESVN_PROJECT}"

src_unpack() {
	subversion_src_unpack || die
	#cd "${S}"
}

src_compile() {
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.9
	./autogen.sh || die
	
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc NEWS AUTHORS README ChangeLog
}
