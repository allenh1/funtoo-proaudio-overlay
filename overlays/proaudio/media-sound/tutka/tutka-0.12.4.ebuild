# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/jacklab/gentoo/media-sound/tutka/tutka-0.12.3.ebuild,v 1.1 2006/04/10 17:19:53 gimpel Exp $

inherit eutils
RESTRICT="nomirror"
IUSE="jack" # lash" # cairo"
DESCRIPTION="A free (as in freedom) tracker style MIDI sequencer for GNU/Linux"
HOMEPAGE="http://www.nongnu.org/tutka"
SRC_URI="http://download.savannah.gnu.org/releases/tutka/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND=">=media-libs/alsa-lib-0.9.0
	>=gnome-base/libgnomeui-2.6
	>=x11-libs/gtk+-2.4
	>=dev-libs/libxml2-2.4.16
	>=gnome-base/libglade-2.4.2
	jack? ( >=media-sound/jack-audio-connection-kit-0.90.0 )"

#src_unpack() {
#	unpack ${A}
#	cd ${S}
#	}

src_compile() {
	#export WANT_AUTOCONF=2.5
	#export WANT_AUTOMAKE=1.6

	#autoconf || die "autoconf failed"
	#autoreconf

	econf $(use_with jack) || die
	sed -i '/GCONF_CONFIG_SOURCE/d' ${S}/Makefile || die "patching Makefile"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
}


pkg_postinst() {
	# More or less copied from gnome2_gconf_install, which didn't work here
	export GCONF_CONFIG_SOURCE=xml::/etc/gconf/gconf.xml.defaults
	einfo "Installing GNOME 2 GConf schemas"
	${ROOT}/usr/bin/gconftool-2 --makefile-install-rule ${S}/tutka.schemas 1>/dev/null
}

#pkg_postrm() {
#	# More or less copied from gnome2_gconf_install, which didn't work here
#	export GCONF_CONFIG_SOURCE=xml::/etc/gconf/gconf.xml.defaults
#	einfo "Uninstalling GNOME 2 GConf schemas"
#	${ROOT}/usr/bin/gconftool-2 --makefile-uninstall-rule tutka.schemas 1>/dev/null
#}
