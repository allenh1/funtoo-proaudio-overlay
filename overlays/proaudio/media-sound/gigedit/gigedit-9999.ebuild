# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils subversion

DESCRIPTION="Gigedit is an instrument editor for Gigasampler files."
HOMEPAGE="http://www.linuxsampler.org"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/gigedit/trunk"
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
	dev-util/pkgconfig"

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
	make_desktop_entry "${PN}" GigEdit "${PN}" "AudioVideo;Audio;Sampler"

	#if use doc; then
	#    mv ${S}/doc/html ${D}/usr/share/doc/${PF}/
	#fi
}
