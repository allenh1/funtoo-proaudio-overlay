# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

inherit eutils subversion # autotools

DESCRIPTION="Midi input plugin for the alsaplayer. It use timidity++ for the output"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk gtk2"

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/alsaplayer/trunk/fftscope"

S=${WORKDIR}/${PN}

DEPEND="media-sound/alsaplayer"

src_unpack() {
	subversion_src_unpack
	
	if use gtk; then
		cd ${S}
		./bootstrap || die "bootstrap failed"
	fi
	
	if use gtk2; then
		cd ${S}/gtk2
		./bootstrap || die "bootstrap gtk2 failed"
	fi
	
}

src_compile() {
	if use gtk; then
	    cd ${S}
	    	econf \
		    ${myconf} \
		    --disable-dependency-tracking \
		    || die "econf failed"

		emake || die "make failed"
	fi
	
	if use gtk2; then
	    cd ${S}/gtk2
		econf \
		    ${myconf} \
		    --disable-dependency-tracking \
		    || die "econf gtk2 failed"

		emake || die "make gtk2 failed"
	fi
	
}

src_install() {
	if use gtk; then
	    cd ${S}
	    	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}" install \
		    || die "make install failed"

		dodoc AUTHORS ChangeLog README
	fi
	
	if use gtk2; then
	    cd ${S}/gtk2
	    	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}-gtk2" install \
		    || die "make install gtk2 failed"

		dodoc AUTHORS ChangeLog README
	fi
}
