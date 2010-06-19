# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

MY_PN="TuxGuitar"
MY_P="${MY_PN}-${PV}-linux-gtk"

DESCRIPTION="Multitrack guitar tablature editor and player with multitrack display, autoscroll while playing, various effects, import and export gp3 and gp4 files, and more."
HOMEPAGE="http://www.tuxguitar.com.ar"
SRC_URI="x86? ( mirror://sourceforge/tuxguitar/${MY_P}-i386.tar.gz )
	amd64? ( mirror://sourceforge/tuxguitar/${MY_P}-x86_64.tar.gz )"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	for i in `find -iname 'CVS'`;do rm -rf ${i};done
}

S="${WORKDIR}/${A/.tar.gz/}"

src_install() {
	dodir "/opt/${MY_P}" "/opt/bin"
	insinto "/opt/${MY_P}"
	doins TuxGuitar  TuxGuitar.jar
	fperms 0755 /opt/${MY_P}/lib/*.so "/opt/${MY_P}/TuxGuitar"
	mv files lang lib examples "${D}/opt/${MY_P}"
	dosym "${D}/opt/${MY_P}/TuxGuitar" /opt/bin/tuxguitar
}

pkg_postinst(){
	 einfo "$P is installed in /opt/${MY_P}"
	 einfo "type tuxguitar to start the application"
	 einfo "some example files are in /opt/${MY_P}/examples"
}
