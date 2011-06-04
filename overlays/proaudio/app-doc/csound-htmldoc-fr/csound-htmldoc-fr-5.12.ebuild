# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/gimp-help/gimp-help-2.6.1.ebuild,v 1.1 2011/02/01 06:46:03 pva Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Documentation html pour csound"
HOMEPAGE="http://csound.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

# Only *not* outdated translations (see, configure.ac) are listed.
# On update do not forgive to check quickreference/Makefile.am for
# QUICKREFERENCE_ALL_LINGUAS. LANGS should include that langs too.

SRC_URI="mirror://sourceforge/csound/Csound${PV}_manual-fr_html.zip"

DEPEND=""
RDEPEND=">=media-sound/csound-5.12"

S=${WORKDIR}/html/

src_compile() { :; }

src_install() {
	insinto /usr/share/doc/csound-${PV}/html/fr
	doins -r *
}
