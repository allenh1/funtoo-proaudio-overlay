# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/gimp-help/gimp-help-2.6.1.ebuild,v 1.1 2011/02/01 06:46:03 pva Exp $

EAPI="3"
#inherit eutils

DESCRIPTION="Meta package for csound html documentation"
HOMEPAGE="http://csound.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="en fr"

SRC_URI=""

DEPEND="en? ( =app-doc/csound-htmldoc-fr-${PV} )
	fr? ( =app-doc/csound-htmldoc-en-${PV} )"
RDEPEND=""
