# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils subversion autotools flag-o-matic toolchain-funcs

DESCRIPTION="Collection of GTK+ widgets geared toward pro-audio apps."
HOMEPAGE="https://developper.berlios.de/projects/phat/"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/phat/trunk/phat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE="debug -doc glade"
DEPEND=">x11-libs/gtk+-2
	doc? ( dev-util/gtk-doc )
	glade? ( dev-util/glade )"

src_unpack() {
	subversion_src_unpack ${A}
	cd "${S}"
	# workaround: bootstrap should not need gtkdocize if no docs are build
	if ! use doc ;then
		esed_check -i -e "s@\(^gtkdocize.*\)@# \1@g" bootstrap
		touch gtk-doc.make
		cd docs
			esed_check -i -e "s@\(^EXTRA_DIST\).*@\1 =@g" Makefile.am
		cd ..
	fi

	./bootstrap
	if [[ $(gcc-major-version)$(gcc-minor-version)$(gcc-micro-version) -ge 413 ]] ; then
		ewarn "Appending -fgnu89-inline to CFLAGS/CXXFLAGS"
		append-flags -fgnu89-inline
	fi
}

src_compile() {
	if use glade; then
		myconf="${myconf} --enable-glade-plugin"
	fi

	econf $(use_enable debug) \
	      $(use_enable doc gtk-doc)\
		  $myconf || die "Configure failed"

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS BUGS NEWS README TODO
	use doc || rm -rf "${D}"/usr/share/gtk-doc/html/${PN}
}
