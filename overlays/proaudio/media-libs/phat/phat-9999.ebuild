# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools flag-o-matic toolchain-funcs

DESCRIPTION="Collection of GTK+ widgets geared toward pro-audio apps."
HOMEPAGE="https://developper.berlios.de/projects/phat/"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/phat/trunk/phat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE="debug doc glade"
DEPEND=">x11-libs/gtk+-2
	doc? ( dev-util/gtk-doc )
	glade? ( dev-util/glade )"

src_unpack() {
	subversion_src_unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/svn-configure-ac-CFLAGS-fix.patch"
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
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS BUGS INSTALL NEWS TODO
}
