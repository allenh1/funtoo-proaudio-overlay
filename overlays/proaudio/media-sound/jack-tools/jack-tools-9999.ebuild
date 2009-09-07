# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit subversion exteutils autotools
inherit autotools darcs

#RESTRICT="mirror"
# lash currently not supported upstream
IUSE=""

DESCRIPTION="a collection of jack tools"
HOMEPAGE="http://slavepianos.org/rd/f/207983/"

#ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
#ESVN_PROJECT="svn.drobilla.net"
EDARCS_REPOSITORY="http://www.slavepianos.org/rd/sw/jack.*/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.109.2
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXext
	media-libs/libsndfile"

DEPEND="${RDEPEND}"

src_unpack() {
	darcs_src_unpack
	cd "${S}"
	./autogen.sh
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc README
}
