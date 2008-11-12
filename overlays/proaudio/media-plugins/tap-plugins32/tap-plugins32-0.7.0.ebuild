# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/tap-plugins/tap-plugins-0.7.0-r1.ebuild,v 1.1 2007/07/06 22:20:30 aballier Exp $
#

inherit multilib toolchain-funcs eutils

IUSE=""

MY_P="${P/32/}"

DESCRIPTION="TAP LADSPA plugins package. Contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="http://tap-plugins.sourceforge.net"
SRC_URI="mirror://sourceforge/tap-plugins/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -*"

DEPEND="media-libs/ladspa-sdk
	~media-plugins/tap-plugins-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${MY_P}-cflags-ldflags.patch"
}

src_compile() {
	multilib_toolchain_setup x86
	emake CC=$(tc-getCC) OPT_CFLAGS="${CFLAGS}" EXTRA_LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
