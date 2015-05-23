# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit exteutils subversion autotools-utils flag-o-matic toolchain-funcs

DESCRIPTION="Collection of GTK+ widgets geared toward pro-audio apps."
HOMEPAGE="https://developer.berlios.de/projects/phat/"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/${PN}/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug doc glade"
DEPEND=">=x11-libs/gtk+-2
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )
	glade? ( dev-util/glade )"

PATCHES=( "${FILESDIR}/${P}-cflags.patch" )
DOCS=( AUTHORS BUGS NEWS README TODO )

AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_AUTORECONF="1"

src_prepare() {
	# workaround: autoreconf should not need gtkdocize if no docs are built
	if ! use doc ;then
		touch gtk-doc.make
		esed_check -i -e "s@\(^EXTRA_DIST\).*@\1 =@g" docs/Makefile.am
	fi

	if [[ $(gcc-major-version)$(gcc-minor-version)$(gcc-micro-version) -ge 413 ]] ; then
		ewarn "Appending -fgnu89-inline to CFLAGS/CXXFLAGS"
		append-flags -fgnu89-inline
	fi
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_enable glade glade-plugin)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc || rm -rf "${D}/usr/share/gtk-doc/html/${PN}"
}
