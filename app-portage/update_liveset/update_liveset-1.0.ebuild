# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit

DESCRIPTION="update your live ebuild set"
HOMEPAGE="http://proaudio.tuxfamily.org/wiki/index.php?title=Main_Page"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="app-portage/gentoolkit"

S="${WORKDIR}"

src_configure() {
	echo "Nothing to configure"
}

src_compile() {
	echo "Nothing to compile"
}

src_install() {
	dobin "${FILESDIR}/update_liveset"
	dodoc "${FILESDIR}/README"
}
