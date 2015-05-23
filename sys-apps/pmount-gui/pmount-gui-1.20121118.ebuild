# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_PV="20121118"
DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui:a=summary"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${PN}-${MY_PV}.tar.gz"
LICENSE="Mikkosoft"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/udev
	sys-apps/pmount
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	# Add gentoo CFLAGS
	sed -i -e "s:-Wextra:-Wextra ${CFLAGS}:" Makefile || die "sed failed"
}

src_install() {
	dobin pmount-gui
	dodoc LICENSE.txt README.txt || die "install documentation failed"
}
