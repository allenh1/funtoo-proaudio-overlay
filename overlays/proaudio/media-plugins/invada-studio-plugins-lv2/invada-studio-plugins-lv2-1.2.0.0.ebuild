# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator toolchain-funcs multilib

DESCRIPTION="Invada lv2 package, contains: Delay, Dynamics, Filters, Reverb, Utility"
HOMEPAGE="https://lauchpad.net/invada-studio/lv2"
MY_PV=$(replace_version_separator 3 '-' )
SRC_URI="https://launchpad.net/invada-studio/lv2/1.2/+download/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
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
	emake INSTALL_SYS_PLUGINS_DIR="/usr/$(get_libdir)/lv2" DESTDIR="${D}" install-sys || die
	dodoc CREDITS README
}
