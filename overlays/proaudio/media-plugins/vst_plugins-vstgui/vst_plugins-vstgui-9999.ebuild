# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion vstplugin

DESCRIPTION="VST GUI wrapper"
HOMEPAGE="http://www.anticore.org/jucetice/?page_id=8"
ESVN_REPO_URI="svn://jacklab.net/eXT2/vstplugins/vstgui"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodir /usr/include/vstgui
	insinto /usr/include/vstgui
	doins *.cpp *.h
}
