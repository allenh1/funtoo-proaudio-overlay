# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="A small helper application that serves as a proxy between an un-LASHified app and the LASH system"
HOMEPAGE="http://tapas.affenbande.org/lash_wrap/"
SRC_URI="http://tapas.affenbande.org/${PN}/${P}.tgz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/boost-1.41.0-r3
	>=dev-libs/glib-2.24.1-r1:2
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	media-sound/lash"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix up CXXFLAGS, LDFLAGS and installing to DESTDIR
	sed -i -e 's/\$(PREFIX)/\$(DESTDIR)&/g' -e "s/-O2/${CXXFLAGS}/" \
		-e "s/\$(CXX) -o/\$(CXX) ${LDFLAGS} -o/" \
		Makefile || die "sed of Makefile failed"

	# fix path of README in manual page
	sed -i -e \
		"s|/usr/share/doc/lashwrap/README|/usr/share/doc/${PF}/README*|g" \
		lash_wrap.man || die "sed of lash_wrap.man failed"
}

src_compile() {
	CXX="$(tc-getCXX)" emake || die "emake failed"
}

src_install() {
	einstall DESTDIR="${D}" PREFIX=/usr || die "einstall failed"
	newman lash_wrap.man lash_wrap.1
	dodoc CHANGELOG README
}
