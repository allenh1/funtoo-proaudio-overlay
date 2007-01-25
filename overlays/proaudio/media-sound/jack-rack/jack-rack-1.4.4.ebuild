# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-rack/jack-rack-1.4.4.ebuild,v 1.1 2005/11/07 14:09:42 matsuu Exp $

IUSE="gnome lash nls xml2"

inherit eutils lash

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="mirror://sourceforge/jack-rack/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="lash? ( >=media-sound/lash-0.4 )
	media-libs/liblrdf
	>=x11-libs/gtk+-2.0.6-r2
	>=media-libs/ladspa-sdk-1.12
	media-sound/jack-audio-connection-kit
	gnome? ( >=gnome-base/libgnomeui-2 )
	nls? ( sys-devel/gettext )
	xml2? ( dev-libs/libxml2 )"

MAKEOPTS="-j1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gtkdep.patch
	# support for lash the successor of ladcca
	#for i in `grep -l -m1 -R LADCCA *`;do sed -i 's/LADCCA/LASH/g' $i || die;done
#	for i in `grep -l -m1 -R ladcca *`;do sed -i 's/ladcca\/ladcca.h/lash\/lash.h/g' $i || die ;done 
#	for i in `grep -l -m1 -R ladcca *`;do sed -i 's/ladcca/lash/g' $i || die;done
#	for i in `grep -l -m1 -R cca *`;do sed -i 's/cca/lash/g' $i || die;done
#	for i in `grep -l -m1 -R CCA *`;do sed -i 's/CCA/LASH/g' $i || die;done
	ladcca_to_lash
}

src_compile() {
	econf \
		`use_enable gnome` \
		`use_enable xml2 xml` \
		`use_enable lash` \
		`use_enable nls` \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
}
