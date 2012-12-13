# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pager/pager-0.ebuild,v 1.3 2009/12/15 19:47:07 abcd Exp $

EAPI="5"

DESCRIPTION="Virtual for LASH library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="python"

DEPEND=""
RDEPEND="|| ( media-sound/lash media-sound/ladish[lash] )
python? ( || ( media-sound/lash[python] media-sound/ladish[python] ) )"
