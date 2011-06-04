# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/gimp-help/gimp-help-2.6.1.ebuild,v 1.1 2011/02/01 06:46:03 pva Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Html documentation for csound"
HOMEPAGE="http://csound.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
SRC_URI="mirror://sourceforge/csound/Csound${PV}_manual_html.zip"

DEPEND=""
RDEPEND=">=media-sound/csound-5.12"

S=${WORKDIR}/html/

src_compile() { :; }

src_install() {
	insinto /usr/share/doc/csound-${PV}/html/en
	doins -r *
}
