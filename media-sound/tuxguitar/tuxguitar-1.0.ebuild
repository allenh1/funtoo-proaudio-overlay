# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

DESCRIPTION="TuxGuitar is a multitrack guitar tablature editor and player written in Java-SWT"
HOMEPAGE="http://www.tuxguitar.com.ar"
MY_P="${P}-linux"
SRC_URI="x86? ( mirror://sourceforge/tuxguitar/${MY_P}-x86.tar.gz )
	ppc? ( mirror://sourceforge/tuxguitar/${MY_P}-ppc.tar.gz )
	amd64? ( mirror://sourceforge/tuxguitar/${MY_P}-x86_64.tar.gz )"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=virtual/jre-1.5"

conv_arch() {
	local ret=""
	use x86 && ret="x86"
	use ppc && ret="ppc"
	use amd64 && ret="x86_64"
	echo $ret
}

S="${WORKDIR}/${MY_P}-$(conv_arch)"
src_install() {
	dodir "/opt/${MY_P}"
	insinto "/opt/${MY_P}"
	doins tuxguitar  tuxguitar.jar
	fperms 0755 /opt/${MY_P}/lib/*.so "/opt/${MY_P}/tuxguitar"
	mv files doc lib share "${D}/opt/${MY_P}"
	cat >>"${WORKDIR}/wrapper" <<EOF
#!/bin/bash
PATH="/opt/${MY_P}:\$PATH" tuxguitar \$@
EOF
	newbin "${WORKDIR}/wrapper" tuxguitar
}

pkg_postinst(){
	 einfo "$P is installed in /opt/${MY_P}"
	 einfo "type tuxguitar to start the application"
#	 einfo "some example files are in /opt/${MY_P}/examples"
}
