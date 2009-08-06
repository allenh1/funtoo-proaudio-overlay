# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
RESTRICT="mirror"

DESCRIPTION="Set of C++ classes for packing and unpacking OSC packets"
HOMEPAGE="http://www.audiomulch.com/~rossb/code/oscpack"

MY_PV="1_0_2"
SRC_URI="http://www.audiomulch.com/~rossb/code/oscpack/${PN}_${MY_PV}.zip"

LICENSE="AS-IT"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="ppc"

S=${WORKDIR}/${PN}

RDEPEND=""

DEPEND="app-arch/unzip
	${RDEPEND}"

#src_unpack() {
#	unpack ${A}
#
#	cd ${S}
#
#}

src_compile() {
	sed -i -e "s:/usr/local:/usr:" -e "s/mkdir bin/mkdir -p bin/g" ${S}/Makefile || die "sed failed"
	if use ppc; then
	    sed -i -e "s:ENDIANESS=OSC_HOST_LITTLE_ENDIAN:ENDIANESS=OSC_HOST_BIG_ENDIAN:" ${S}/Makefile || die "sed ppc failed"
	fi

	emake || die "make failed"
	emake lib || "make lib failed"
}

src_install() {
	dodoc CHANGES LICENSE README TODO

	dolib liboscpack.so.1.0.2
	insinto /usr/include/oscpack/ip
	doins ip/*.h
	insinto /usr/include/oscpack/osc
	doins osc/*.h
	}
