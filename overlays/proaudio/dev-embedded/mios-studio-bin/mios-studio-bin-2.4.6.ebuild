# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/acroread/acroread-9.5.5.ebuild,v 1.4 2013/07/13 19:07:04 zmedico Exp $

EAPI=5

inherit eutils

DESCRIPTION="uCApps.de MIOS Studio"
SRC_URI="http://ucapps.de/mios_studio/MIOS_Studio_2_4_6.tar.gz"
HOMEPAGE="http://ucapps.de/"

LICENSE=""
KEYWORDS="-* ~amd64 ~x86"
SLOT="0"
IUSE=""

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs )"

INSTALLDIR=/opt

S="${WORKDIR}"

# remove bundled libs to force use of system version, bug 340527
REMOVELIBS="libcrypto libssl"

src_install() {
	exeinto /opt/mios-studio-${PV}/bin
	doexe MIOS_Studio
	dosym /opt/mios-studio-${PV}/bin/MIOS_Studio /opt/bin/MIOS_Studio
}
