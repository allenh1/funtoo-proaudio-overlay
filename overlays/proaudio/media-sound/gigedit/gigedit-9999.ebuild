# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cvs

ECVS_SERVER="cvs.linuxsampler.org:/var/cvs/linuxsampler"
ECVS_MODULE="gigedit"

DESCRIPTION="Gigedit is an instrument editor for Gigasampler files."
HOMEPAGE="http://www.linuxsampler.org"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

# this is a bleeding edge CVS ebuild, chances are high that we need a
# stack trace, so don't strip symbols
RESTRICT="strip"

#TODO: linuxsampler is actually an optional dependency, thus a candidate
#      for a use flag.
RDEPEND="
	>=dev-cpp/gtkmm-2.4.10
	>=media-libs/libgig-9999
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-9999
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfg"

S="${WORKDIR}/${ECVS_MODULE}"

src_configure() {
	make -f Makefile.cvs
	econf || die "./configure failed"
}

src_compile() {
	emake -j1 || die "make failed"

	# docs are currently automatically tried to be built
	# on 'make (all)', so we don't need this now:
	#if use doc; then
	#   make docs || die "make docs failed"
	#fi
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README NEWS

	#if use doc; then
	#    mv ${S}/doc/html ${D}/usr/share/doc/${PF}/
	#fi
}
