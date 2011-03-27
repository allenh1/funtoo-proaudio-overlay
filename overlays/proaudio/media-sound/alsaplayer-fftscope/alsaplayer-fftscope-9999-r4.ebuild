# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

EAPI=2
inherit eutils git #autotools

DESCRIPTION="FftScope external visualization scope for AlsaPlayer. It is a good starting point for others."
HOMEPAGE="http://www.alsaplayer.org/"
EGIT_REPO_URI="git://github.com/alsaplayer/alsaplayer.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/${PN}

DEPEND="<media-sound/alsaplayer-9999
	=dev-libs/glib-1.2*"

src_prepare() {
	cd ${S}/attic/fftscope

	./bootstrap || die "bootstrap failed"
}

src_configure() {
	cd ${S}/attic/fftscope

	    	econf \
		    ${myconf} \
		    --disable-dependency-tracking \
		    || die "econf failed"
}

src_compile() {
	cd ${S}/attic/fftscope

		emake || die "make failed"
}

src_install() {
	cd ${S}/attic/fftscope

	    	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}" install \
		    || die "make install failed"

		dodoc AUTHORS ChangeLog README
}
