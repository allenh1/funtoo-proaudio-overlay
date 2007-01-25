# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="Collection of GTK+ widgets geared toward pro-audio apps."
HOMEPAGE="https://developper.berlios.de/projects/phat/"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/phat/trunk/phat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"

S="${WORKDIR}/${PN}"

IUSE="debug doc"
DEPEND=">x11-libs/gtk+-2
	doc? ( dev-util/gtk-doc )"

src_unpack() {
	subversion_src_unpack ${A}
	cd "${S}"
	./bootstrap
}

src_compile() {
	econf $(use_enable debug) \
	      $(use_enable doc gtk-doc) || die "Configure failed"

	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS BUGS INSTALL NEWS TODO
}
