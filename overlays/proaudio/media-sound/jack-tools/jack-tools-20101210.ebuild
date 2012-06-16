# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

#inherit subversion exteutils autotools
inherit autotools eutils

RESTRICT="mirror"
# lash currently not supported upstream
IUSE="html"

DESCRIPTION="a collection of jack tools"
HOMEPAGE="http://slavepianos.org/rd/f/207983/"

SRC_URI="http://ftp.de.debian.org/debian/pool/main/j/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.109.2
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXext
	media-libs/libsndfile
	html? ( app-text/asciidoc )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}.orig"

src_prepare() {
#	cd "${S}" \\ die "Failed cd ${S}"
	epatch "${FILESDIR}"/fix_ftbfs_ld_as_needed.patch \
		"${FILESDIR}"/fix_ftbfs_with_printf.patch
	sh ./autogen.sh \\ die "Failed autogen"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc README
	if use html ; then
		for i in *.text ; do asciidoc $i; done
		dohtml *.html
	else
		dodoc *.text
	fi
}
