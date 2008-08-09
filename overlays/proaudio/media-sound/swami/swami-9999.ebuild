# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic subversion

DESCRIPTION="an instrument editor for MIDI music composition and a sampler frontend"
HOMEPAGE="http://swami.sourceforge.net"
#SRC_URI="mirror://sourceforge/${PN}/${P/_/}.tar.bz2"

ESVN_REPO_URI="https://swami.svn.sourceforge.net/svnroot/swami/trunk/swami"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug nls python"

RDEPEND="media-libs/alsa-lib
	=x11-libs/gtk+-2*
	>=dev-libs/glib-2.0
	>=gnome-base/libglade-2.6.0
	x11-libs/gtksourceview
	>=dev-python/pygtk-2.12.0-r1
	media-libs/libpng
	>=sci-libs/fftw-3.1
	>=media-sound/fluidsynth-1.0.4
	>=media-libs/libsndfile-1.0.0
	=dev-libs/libinstpatch-9999
	python? ( >=dev-lang/python-2.4 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	# fails with --as-needed
	filter-ldflags -Wl,--as-needed --as-needed

	./autogen.sh
	use amd64 && myconf='--with-pic'
	econf ${myconf} \
		--disable-gtktest --disable-audiofiletest \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable python) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
	doicon "${D}"/usr/share/icons/hicolor/48x48/apps/swami-2.png
}
