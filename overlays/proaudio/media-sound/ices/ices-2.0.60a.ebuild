# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

IUSE=""

RESTRICT="nomirror"

MY_P="${PN}-$(replace_version_separator "2" "-kh")"
DESCRIPTION="icecast OGG streaming client. supports on the fly re-encoding, and the jack-audio-connection-kit"
SRC_URI="http://www.mediacast1.com/~karl/${MY_P}.tar.bz2"
HOMEPAGE="http://www.icecast.org/ices.php"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc64"

DEPEND="dev-libs/libxml2
	dev-util/pkgconfig
	>=media-libs/libshout-2.0
	>=media-libs/libvorbis-1.0"

S="${WORKDIR}/${MY_P}"

src_compile ()
{
	econf --sysconfdir=/etc/ices2 || die "configure failed"
	emake || die "make failed"
}

src_install ()
{
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS README TODO

	# Add the stock configs...
	dodir /etc/ices2
	mv ${D}usr/share/ices/ices-live.xml \
		${D}etc/ices2/ices-live.xml.dist
	mv ${D}usr/share/ices/ices-playlist.xml \
		${D}etc/ices2/ices-playlist.xml.dist

	# Move the html to it's proper location...
	dodir /usr/share/doc/${P}/html
	mv ${D}usr/share/ices/*.html ${D}usr/share/doc/${P}/html
	mv ${D}usr/share/ices/style.css ${D}usr/share/doc/${P}/html

	# Nothing is left here after things are moved...
	rmdir ${D}usr/share/ices
}
