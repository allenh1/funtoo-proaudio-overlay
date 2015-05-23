# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base multilib toolchain-funcs

DESCRIPTION="NJL LADSPA audio plugins/effects"
HOMEPAGE="http://devel.tlrmx.org/audio"
SRC_URI="http://devel.tlrmx.org/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"

S=${WORKDIR}/${PN}
RESTRICT="mirror"

DOCS=( PLUGINS README )

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_compile() {
	base_src_make CC="$(tc-getCC)"
}

src_install() {
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins eir_1923.so noise_1921.so noise_1922.so risset_1924.so
	base_src_install_docs
}
