# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

MY_PN="TuxGuitar-linux-SDK"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Multitrack guitar tablature editor and player with multitrack display, autoscroll while playing, various effects, import and export gp3 and gp4 files, and more."
HOMEPAGE="http://www.tuxguitar.com.ar"
SRC_URI="mirror://sourceforge/tuxguitar/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	for i in `find -iname 'CVS'`;do rm -rf ${i};done
}

S="${WORKDIR}/${MY_P}"

src_install() {
	dodir "/opt/${MY_P}" "/opt/bin"
	insinto "/opt/${MY_P}"
	doins *.so TuxGuitar
	fperms 0755 "/opt/${MY_P}/"*.so "/opt/${MY_P}/TuxGuitar"
	mv files lang lib examples "${D}/opt/${MY_P}"
	dosym "${D}/opt/${MY_P}/TuxGuitar" /opt/bin/tuxguitar
}

pkg_postinst(){
	 einfo "$P is installed in /opt/${MY_P}"
	 einfo "type tuxguitar to start the application"
	 einfo "some example files are in /opt/${MY_P}/examples"
}
