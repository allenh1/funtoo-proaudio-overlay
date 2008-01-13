# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

#RESTRICT="nomirror"
DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash"
SRC_URI="http://download.savannah.nongnu.org/releases/lash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="media-libs/alsa-lib
	!media-libs/ladcca
	!media-libs/lash
	media-sound/jack-audio-connection-kit
	>=x11-libs/gtk+-2.0"

#src_unpack() {
#	unpack ${P}.tar.gz || die
#}

src_compile() {
	econf --disable-serv-inst || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst(){
	if [ ! $(grep -q ^lash /etc/services) ] || [ $(grep -q ^ladcca /etc/services) ] ; then
		# cleanup trailing blank lines in /etc/service
		sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
		# check for old ladcca entries and remove
		if grep -q ^ladcca /etc/services; then
			sed -i /ladcca/d /etc/services
		fi
		# add new lash entry
		if ! grep -q ^lash /etc/services ; then
			cat >>/etc/services<<-EOF

lash		14541/tcp			# LASH client/server protocol
EOF
		fi
	fi
}

pkg_postrm(){
	# cleanup /etc/services
	if grep -q ^lash /etc/services; then
		einfo "cleaning lash entries frome /etc/services"
		sed -i /lash/d /etc/services
	fi
	# cleanup trailing blank lines in /etc/service
	sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' /etc/services
	einfo "if programs which use lash fails try:"
	einfo "revdep-rebuild --library="liblash.so.*""
}
