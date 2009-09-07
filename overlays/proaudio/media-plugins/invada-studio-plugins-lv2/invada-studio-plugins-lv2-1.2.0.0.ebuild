# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs

DESCRIPTION="Invada lv2 package, contains: Delay, Dynamics, Filters, Reverb, Utility"
HOMEPAGE="http://www.invadarecords.com/Downloads.php?ID=00000264"
MY_PV=$(replace_version_separator 3 '-' )
SRC_URI="http://www.invadarecords.com/downloads/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2
	x11-libs/cairo
	>=dev-util/glade-2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

src_compile() {
	tc-export AR CC
	emake || die
}
src_install() {
	emake INSTALL_SYS_PLUGINS_DIR="/usr/lib/lv2" DESTDIR="${D}" install-sys || die
	dodoc COPYING CREDITS README
}
