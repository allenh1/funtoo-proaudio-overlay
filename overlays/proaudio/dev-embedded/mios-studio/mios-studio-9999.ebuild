# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/acroread/acroread-9.5.5.ebuild,v 1.4 2013/07/13 19:07:04 zmedico Exp $

EAPI=5

inherit eutils subversion

DESCRIPTION="uCApps.de MIOS Studio"
HOMEPAGE="http://ucapps.de/"

ESVN_REPO_URI="svn://svnmios.midibox.org/mios32/trunk/tools"
ESVN_PROJECT="mios32_tools"

LICENSE="TAPR-NCL"
KEYWORDS="-* ~amd64 ~x86"
SLOT="0"
IUSE="debug"

RESTRICT="strip mirror"

DEPEND="app-arch/unzip"

RRDEPEND="=media-libs/freetype-2*
	>=media-libs/alsa-lib-0.9
	>=x11-libs/libX11-1.0.1-r1"

S="${WORKDIR}"

src_prepare() {
	cd "${S}/juce"
	unzip unpack_me.zip || die
}

src_compile() {
	local myconf=""
		use debug && myconf="CONFIG=Debug" || myconf="CONFIG=Release"
	
	cd "${S}/mios_studio/Builds/Linux"
	emake "${myconf}"
}

src_install() {
	cd "${S}/mios_studio/Builds/Linux/build"
	exeinto /usr/bin
	doexe MIOS_Studio
}
