# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="libsamplerate mmx sse"
RESTRICT="mirror"

inherit gnuconfig eutils

DESCRIPTION="GNUsound is a sound editor for Linux/x86"
HOMEPAGE="http://gnusound.sourceforge.net/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
# -amd64, -sparc: 0.6.2 - eradicator - segfault on startup
# added ~amd64 , seems to work now (0.7)
KEYWORDS="~amd64 ~x86 -sparc"

DEPEND=">=gnome-base/libglade-2.0.1
	>=gnome-base/libgnomeui-2.2.0.1
	>=media-libs/audiofile-0.2.3
	libsamplerate? ( media-libs/libsamplerate )"

src_unpack() {
	unpack ${A} || die "unpack failure"
	epatch "${FILESDIR}/gnusound_0.7.4-5.diff.bz2"
	cd "${S}" || die "workdir not found"

	# remove this patch as it cause ffmpeg linkage problems
	rm -f "${S}/debian/patches/03_ffmpeg_config.patch"
	rm -f "${S}/debian/patches/11_ffmpeg_api_changes.patch"

	for i in `ls  "${S}/debian/patches"`;do
		epatch "${S}/debian/patches/$i"
	done
	epatch  "${FILESDIR}/gnusound-ffmpeg-struct.patch"
	#rm -f doc/Makefile || die "could not remove doc Makefile"
	#rm -f modules/Makefile || die "could not remove modules Makefile"
	sed -i "s:docrootdir:datadir:" doc/Makefile.in

	epatch "${FILESDIR}/${P}-destdir.patch"

	gnuconfig_update
	./autogen.sh
}

src_compile() {
	econf \
		$(use_with libsamplerate) \
		$(use_enable mmx fastminmax) \
		$(use_enable sse fastmemcpy) \
		--enable-optimization \
		|| die "Configure failure"
	emake || die "Make failure"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	doman doc/gnusound.1
	dodoc README NOTES TODO CHANGES

	# mv desktop entry to right location
	dodir /usr/share/applications/
	mv "${D}/usr/share/gnome/apps/Multimedia/gnusound.desktop" \
		"${D}/usr/share/applications/"
	rm -rf "${D}/usr/share/gnome/apps/"
}
