# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

MY_PN="fvwm-crystal/fvwm"

DESCRIPTION="Configurable and full featured theme for FVWM-Crystal, tuned for audio work."
HOMEPAGE="http://crystalaudio.tuxfamily.org/"

ESVN_REPO_URI="svn://svn.tuxfamily.org/svnroot/crystalaudio/crystalaudio/trunk/crystal"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsaplayer"
RDEPEND="|| ( =x11-wm/fvwm-20070204 =x11-wm/fvwm-crystal-9999 )
	x11-themes/fvwm-crystal
	media-sound/aumix
	x11-misc/habak
	alsaplayer? ( 	media-sound/alsaplayer
			sys-devel/bc)
	media-sound/qjackctl"

#S=${WORKDIR}/${MY_P}
src_unpack(){
	subversion_src_unpack
}

src_compile() {
	einfo "There is nothing to compile."
}

src_install() {
	cd ${S}
	dodoc AUTHORS COPYING INSTALL NEWS README
	
	dodir "/usr/share/${MY_PN}" || die "dodir failed"
	cp -r Applications components decorations icons locale preferences recipes scripts \
		wallpapers "${D}/usr/share/${MY_PN}"
}

